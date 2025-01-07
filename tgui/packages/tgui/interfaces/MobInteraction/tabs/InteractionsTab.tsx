import { useBackend, useLocalState } from '../../../backend';
import {
  Box,
  Button,
  Collapsible,
  NoticeBox,
  Section,
  Stack,
} from '../../../components';

type InteractionsInfo = {
  categories: string[];
  interactions: Record<string, string[]>;
  descriptions: Record<string, string>;
  colors: Record<string, string>;
  block_interact: boolean;
  favorite_interactions: string[];
  ref_user: string;
  ref_self: string;
  self: string;
};

export const InteractionsTab = () => {
  const { act, data } = useBackend<InteractionsInfo>();
  const {
    categories = [],
    interactions,
    descriptions,
    colors,
    block_interact,
    favorite_interactions = [],
    ref_user,
    ref_self,
    self,
  } = data;

  const [searchText] = useLocalState('searchText', '');
  const [inFavorites] = useLocalState('inFavorites', false);

  // Filter interactions based on search text and favorites
  const filterInteractions = (category: string) => {
    let categoryInteractions = interactions[category] || [];
    if (searchText) {
      categoryInteractions = categoryInteractions.filter((interaction) =>
        interaction.toLowerCase().includes(searchText.toLowerCase()),
      );
    }
    if (inFavorites) {
      categoryInteractions = categoryInteractions.filter((interaction) =>
        favorite_interactions.includes(interaction),
      );
    }
    return categoryInteractions;
  };

  return (
    <Stack vertical fill>
      <Stack.Item>
        <NoticeBox>
          {block_interact ? 'Unable to Interact' : 'Able to Interact'}
        </NoticeBox>
      </Stack.Item>
      <Stack.Item grow>
        {categories.map((category) => {
          const filteredInteractions = filterInteractions(category);
          if (filteredInteractions.length === 0) {
            return null;
          }
          return (
            <Collapsible
              key={category}
              title={category}
              buttons={
                <Box inline color="grey" fontSize={0.9}>
                  {filteredInteractions.length}
                  {' interactions'}
                </Box>
              }
            >
              <Section fill>
                <Stack vertical>
                  {filteredInteractions.map((interaction) => (
                    <Stack.Item key={interaction}>
                      <Stack fill>
                        <Stack.Item grow>
                          <Button
                            fluid
                            color={
                              block_interact ? 'grey' : colors[interaction]
                            }
                            content={interaction}
                            tooltip={descriptions[interaction]}
                            disabled={block_interact}
                            onClick={() =>
                              act('interact', {
                                interaction: interaction,
                                selfref: ref_self,
                                userref: ref_user,
                              })
                            }
                          />
                        </Stack.Item>
                        <Stack.Item>
                          <Button
                            icon={
                              favorite_interactions.includes(interaction)
                                ? 'star'
                                : 'star-o'
                            }
                            color={
                              favorite_interactions.includes(interaction)
                                ? 'yellow'
                                : 'default'
                            }
                            tooltip={`${
                              favorite_interactions.includes(interaction)
                                ? 'Remove from'
                                : 'Add to'
                            } favorites`}
                            onClick={() =>
                              act('favorite', {
                                interaction: interaction,
                              })
                            }
                          />
                        </Stack.Item>
                      </Stack>
                    </Stack.Item>
                  ))}
                </Stack>
              </Section>
            </Collapsible>
          );
        })}
      </Stack.Item>
    </Stack>
  );
};
