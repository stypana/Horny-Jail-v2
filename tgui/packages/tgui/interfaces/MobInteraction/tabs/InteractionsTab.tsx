import { createSearch } from 'common/string';

import { useBackend, useLocalState } from '../../../backend';
import { Button, Icon, Section, Stack, Tooltip } from '../../../components';
import { Box } from '../../../components';

type ContentInfo = {
  interactions: InteractionData[];
  favorite_interactions: string[];
  user_is_blacklisted: boolean;
  target_is_blacklisted: boolean;
  extreme_pref: boolean;
  unholy_pref: boolean;
  isTargetSelf: boolean;
  target_has_active_player: number;
  theyAllowExtreme: boolean;
  theyAllowLewd: boolean;
  theyAllowUnholy: boolean;
  theyHaveBondage: boolean;
  verb_consent: boolean;
  max_distance: number;
  required_from_user: number;
  required_from_user_exposed: number;
  required_from_user_unexposed: number;
  user_num_feet: number;
  required_from_target: number;
  required_from_target_exposed: number;
  required_from_target_unexposed: number;
  target_num_feet: number;
};

type InteractionData = {
  key: string;
  desc: string;
  type: number;
  additionalDetails: Array<{
    icon: string;
    info: string;
  }>;
  interactionFlags: number;
  maxDistance: number;
  required_from_user?: number;
  required_from_user_exposed?: number;
  required_from_user_unexposed?: number;
  user_num_feet?: number;
  required_from_target?: number;
  required_from_target_exposed?: number;
  required_from_target_unexposed?: number;
  target_num_feet?: number;
};

const INTERACTION_NORMAL = 0;
const INTERACTION_LEWD = 1;
const INTERACTION_EXTREME = 2;
const INTERACTION_UNHOLY = 3; // SPLURT EDIT

const INTERACTION_FLAG_ADJACENT = 1 << 0;
const INTERACTION_FLAG_EXTREME_CONTENT = 1 << 1;
const INTERACTION_FLAG_OOC_CONSENT = 1 << 2;
const INTERACTION_FLAG_TARGET_NOT_TIRED = 1 << 3;
const INTERACTION_FLAG_USER_IS_TARGET = 1 << 4;
const INTERACTION_FLAG_USER_NOT_TIRED = 1 << 5;
const INTERACTION_FLAG_UNHOLY_CONTENT = 1 << 6;
const INTERACTION_FLAG_REQUIRE_BONDAGE = 1 << 7;

export const InteractionsTab = () => {
  const { act, data } = useBackend<ContentInfo>();
  const [searchText, setSearchText] = useLocalState('searchText', '');
  const [inFavorites, setInFavorites] = useLocalState('inFavorites', false);

  const interactions = sortInteractions(
    data.interactions || [],
    searchText,
    data,
  );
  const favorite_interactions = data.favorite_interactions || [];
  const valid_favorites = interactions.filter((interaction) =>
    favorite_interactions.includes(interaction.key),
  );
  const interactions_to_display = inFavorites ? valid_favorites : interactions;

  const { user_is_blacklisted, target_is_blacklisted } = data;

  return (
    <Stack vertical>
      {interactions_to_display.length ? (
        interactions_to_display.map((interaction) => (
          <Stack.Item key={interaction.key}>
            <Stack fill>
              <Stack.Item grow>
                <Button
                  content={interaction.desc}
                  color={
                    interaction.type === INTERACTION_EXTREME
                      ? 'red'
                      : interaction.type
                        ? 'pink'
                        : 'default'
                  }
                  fluid
                  mb={-0.7}
                  onClick={() =>
                    act('interact', {
                      interaction: interaction.key,
                    })
                  }
                >
                  <Box textAlign="right" fillPositionedParent>
                    {interaction.additionalDetails?.map((detail) => (
                      <Tooltip key={detail.icon} content={detail.info}>
                        <Icon name={detail.icon} />
                      </Tooltip>
                    ))}
                  </Box>
                </Button>
              </Stack.Item>
              <Stack.Item>
                <Button
                  icon="star"
                  tooltip={`${
                    favorite_interactions.includes(interaction.key)
                      ? 'Remove from'
                      : 'Add to'
                  } favorites`}
                  onClick={() =>
                    act('favorite', {
                      interaction: interaction.key,
                    })
                  }
                  selected={favorite_interactions.includes(interaction.key)}
                />
              </Stack.Item>
            </Stack>
          </Stack.Item>
        ))
      ) : (
        <Section align="center">
          {user_is_blacklisted || target_is_blacklisted
            ? `${user_is_blacklisted ? 'Your' : 'Their'} mob type is blacklisted from interactions`
            : searchText
              ? 'No matching results.'
              : inFavorites
                ? favorite_interactions.length
                  ? 'No favorites available. Maybe you or your partner lack something your favorites require.'
                  : 'You have no favorites! Choose some by clicking the star to the right of any interactions!'
                : 'No interactions available.'}
        </Section>
      )}
    </Stack>
  );
};

/**
 * Interaction sorter! also search box
 */
const sortInteractions = (
  interactions: InteractionData[],
  searchText = '',
  data: ContentInfo,
) => {
  const testSearch = createSearch<InteractionData>(
    searchText,
    (interaction) => interaction.desc,
  );

  const {
    extreme_pref,
    unholy_pref,
    isTargetSelf,
    target_has_active_player,
    target_is_blacklisted,
    theyAllowExtreme,
    theyAllowLewd,
    theyAllowUnholy,
    user_is_blacklisted,
    verb_consent,
    max_distance,
    required_from_user,
    required_from_user_exposed,
    required_from_user_unexposed,
    user_num_feet,
    required_from_target,
    required_from_target_exposed,
    required_from_target_unexposed,
    target_num_feet,
  } = data;

  return interactions
    .filter((interaction) => !user_is_blacklisted && !target_is_blacklisted)
    .filter((interaction) => !searchText || testSearch(interaction))
    .filter((interaction) => {
      // Filter based on interaction type and preferences
      if (interaction.type === INTERACTION_NORMAL) {
        return true;
      }
      if (interaction.type === INTERACTION_LEWD) {
        return verb_consent;
      }
      if (interaction.type === INTERACTION_UNHOLY) {
        return verb_consent && unholy_pref;
      }
      return verb_consent && extreme_pref;
    })
    .filter((interaction) => {
      // Filter based on target's preferences
      if (isTargetSelf || target_has_active_player === 0) {
        return true;
      }
      if (interaction.type === INTERACTION_NORMAL) {
        return true;
      }
      if (interaction.type === INTERACTION_LEWD) {
        return theyAllowLewd;
      }
      if (interaction.type === INTERACTION_UNHOLY) {
        return theyAllowLewd && theyAllowUnholy;
      }
      return theyAllowLewd && theyAllowExtreme;
    })
    .filter((interaction) =>
      isTargetSelf
        ? interaction.interactionFlags & INTERACTION_FLAG_USER_IS_TARGET
        : !(interaction.interactionFlags & INTERACTION_FLAG_USER_IS_TARGET),
    )
    .filter(
      (interaction) =>
        !(!isTargetSelf && target_has_active_player === 1) ||
        !(interaction.interactionFlags & INTERACTION_FLAG_OOC_CONSENT),
    )
    .filter((interaction) => max_distance <= interaction.maxDistance)
    .filter((interaction) => {
      if (!interaction.required_from_user) {
        return true;
      }
      return (
        (required_from_user & interaction.required_from_user) ===
        interaction.required_from_user
      );
    })
    .filter((interaction) => {
      const exposed =
        !interaction.required_from_user_exposed ||
        (interaction.required_from_user_exposed &
          required_from_user_exposed) ===
          interaction.required_from_user_exposed;
      const unexposed =
        !interaction.required_from_user_unexposed ||
        (interaction.required_from_user_unexposed &
          required_from_user_unexposed) ===
          interaction.required_from_user_unexposed;

      if (
        interaction.required_from_user_exposed &&
        interaction.required_from_user_unexposed
      ) {
        return exposed || unexposed;
      }
      return exposed && unexposed;
    })
    .filter(
      (interaction) =>
        !interaction.user_num_feet ||
        interaction.user_num_feet <= user_num_feet,
    )
    .filter((interaction) => {
      if (!interaction.required_from_target) {
        return true;
      }
      return (
        (required_from_target & interaction.required_from_target) ===
        interaction.required_from_target
      );
    })
    .filter((interaction) => {
      const exposed =
        !interaction.required_from_target_exposed ||
        (interaction.required_from_target_exposed &
          required_from_target_exposed) ===
          interaction.required_from_target_exposed;
      const unexposed =
        !interaction.required_from_target_unexposed ||
        (interaction.required_from_target_unexposed &
          required_from_target_unexposed) ===
          interaction.required_from_target_unexposed;

      if (
        interaction.required_from_target_exposed &&
        interaction.required_from_target_unexposed
      ) {
        return exposed || unexposed;
      }
      return exposed && unexposed;
    })
    .filter(
      (interaction) =>
        !interaction.target_num_feet ||
        interaction.target_num_feet <= target_num_feet,
    )
    .sort((a, b) => a.desc.localeCompare(b.desc));
};
