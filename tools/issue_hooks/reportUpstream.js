const core = require('@actions/core');

/**
 * Parses the command from the comment and returns the target repository information
 * @param {string} command - The command to parse
 * @returns {Object} - Object containing valid flag, target info, and any error message
 */
export function parseCommand(command) {
    console.log('Starting command parsing...');
    const parts = command.trim().split(' ');

    // Default to bubber if no target specified
    if (parts.length === 1) {
        console.log('No target specified, defaulting to bubber');
        return {
            valid: true,
            target: 'bubber',
            owner: 'Bubberstation',
            repo: 'Bubberstation'
        };
    }

    if (parts.length !== 2) {
        console.log('Invalid command format detected');
        return {
            valid: false,
            error: 'Invalid command format. Use `/report_upstream` or `/report_upstream tg`'
        };
    }

    const target = parts[1].toLowerCase();
    console.log(`Target specified: ${target}`);

    switch (target) {
        case 'tg':
            return {
                valid: true,
                target: 'tg',
                owner: 'tgstation',
                repo: 'tgstation'
            };
        case 'bubber':
            return {
                valid: true,
                target: 'bubber',
                owner: 'Bubberstation',
                repo: 'Bubberstation'
            };
        case 'testing':
            return {
                valid: true,
                target: 'testing',
                owner: 'MosleyTheMalO',
                repo: 'Bubberstation'
            };
        default:
            console.log(`Invalid target specified: ${target}`);
            return {
                valid: false,
                error: 'Invalid target. Use `tg`, or omit target to report to Bubberstation'
            };
    }
}

/**
 * Checks if the user has maintainer permissions
 * @param {Object} github - GitHub API client
 * @param {Object} context - GitHub Actions context
 * @returns {Promise<boolean>} - Whether the user is a maintainer
 */
export async function checkUserPermissions(github, context) {
    console.log('Checking user permissions...');
    const response = await github.rest.repos.getCollaboratorPermissionLevel({
        owner: context.repo.owner,
        repo: context.repo.repo,
        username: context.actor
    });
    console.log(`User permission level: ${response.data.permission}`);
    const isMaintainer = response.data.permission === 'maintain' ||
                        response.data.permission === 'admin' ||
                        response.data.permission === 'write';
    console.log(`Is maintainer: ${isMaintainer}`);
    return isMaintainer;
}

/**
 * Gets the details of the current issue
 * @param {Object} github - GitHub API client
 * @param {Object} context - GitHub Actions context
 * @returns {Promise<Object>} - Issue details
 */
export async function getIssueDetails(github, context) {
    console.log('Fetching issue details...');
    const issue = await github.rest.issues.get({
        owner: context.repo.owner,
        repo: context.repo.repo,
        issue_number: context.issue.number
    });
    console.log(`Issue title: ${issue.data.title}`);
    console.log(`Issue has ${issue.data.labels.length} labels`);
    return {
        title: issue.data.title,
        body: issue.data.body,
        labels: issue.data.labels.map(label => label.name),
        html_url: issue.data.html_url
    };
}

/**
 * Checks if an issue with the same title exists in the target repository
 * @param {Object} github - GitHub API client
 * @param {string} owner - Repository owner
 * @param {string} repo - Repository name
 * @param {string} title - Issue title to search for
 * @returns {Promise<Object>} - Object containing whether issue exists and its URL if found
 */
export async function checkExistingIssue(github, owner, repo, title) {
    console.log('Checking for existing upstream issue...');
    const searchQuery = `repo:${owner}/${repo} in:title ${title}`;
    console.log(`Search query: ${searchQuery}`);

    try {
        const searchResults = await github.rest.search.issuesAndPullRequests({
            q: searchQuery
        });
        console.log(`Found ${searchResults.data.items.length} potential matches`);

        const existingIssue = searchResults.data.items.find(item =>
            item.title.toLowerCase() === title.toLowerCase()
        );

        if (existingIssue) {
            console.log(`Found existing issue: ${existingIssue.html_url}`);
            return {
                exists: true,
                url: existingIssue.html_url
            };
        }

        console.log('No existing issue found');
        return { exists: false };
    } catch (error) {
        console.error('Error searching for existing issues:', error);
        console.error('Error details:', {
            message: error.message,
            status: error.status,
            response: error.response?.data
        });
        throw error;
    }
}

/**
 * Creates a new issue in the target repository
 * @param {Object} github - GitHub API client
 * @param {Object} context - GitHub Actions context
 * @param {Object} target - Target repository info
 * @param {Object} issue - Issue details
 * @returns {Promise<Object>} - Created issue info
 */
export async function createUpstreamIssue(github, context, target, issue) {
    console.log('Attempting to create upstream issue...');
    try {
        const newIssue = await github.rest.issues.create({
            owner: target.owner,
            repo: target.repo,
            title: issue.title,
            body: `# Original issue: ${issue.html_url}\n\n${issue.body}`,
            labels: issue.labels
        });

        if (!newIssue || !newIssue.data || !newIssue.data.html_url) {
            throw new Error('Failed to create issue: Invalid response from GitHub API');
        }

        console.log(`Successfully created issue: ${newIssue.data.html_url}`);
        return {
            success: true,
            url: newIssue.data.html_url
        };
    } catch (error) {
        console.error('Failed to create upstream issue:', error);
        console.error('Error details:', {
            message: error.message,
            status: error.status,
            response: error.response?.data
        });
        return {
            success: false,
            error: error.message
        };
    }
}

/**
 * Adds a comment to the original issue
 * @param {Object} github - GitHub API client
 * @param {Object} context - GitHub Actions context
 * @param {string} command - Original command
 * @param {string} target - Target repository name
 * @param {string} url - Created issue URL
 * @param {string} error - Error message if any
 */
export async function addComment(github, context, command, target, url, error) {
    console.log('Adding comment to original issue...');
    let body;
    if (error) {
        body = `> ${command}\n\n❌ Failed to report issue to ${target}: ${error}`;
    } else {
        body = `> ${command}\n\n✅ Issue successfully reported to ${target}: ${url}`;
    }

    await github.rest.issues.createComment({
        owner: context.repo.owner,
        repo: context.repo.repo,
        issue_number: context.issue.number,
        body: body
    });
}

/**
 * Main function to handle the report upstream workflow
 * @param {Object} github - GitHub API client
 * @param {Object} context - GitHub Actions context
 */
export async function reportUpstream({ github, context }) {
    const command = context.payload.comment.body;
    const commandResult = parseCommand(command);

    if (!commandResult.valid) {
        await addComment(github, context, command, null, null, commandResult.error);
        return;
    }

    const isMaintainer = await checkUserPermissions(github, context);
    if (!isMaintainer) {
        await addComment(github, context, command, null, null, 'You must be a maintainer to report issues upstream');
        return;
    }

    const issueDetails = await getIssueDetails(github, context);
    const existingIssue = await checkExistingIssue(
        github,
        commandResult.owner,
        commandResult.repo,
        issueDetails.title
    );

    if (existingIssue.exists) {
        await addComment(
            github,
            context,
            command,
            commandResult.target,
            existingIssue.url,
            null
        );
        return;
    }

    const createResult = await createUpstreamIssue(
        github,
        context,
        {
            owner: commandResult.owner,
            repo: commandResult.repo
        },
        issueDetails
    );

    await addComment(
        github,
        context,
        command,
        commandResult.target,
        createResult.url,
        createResult.error
    );
}
