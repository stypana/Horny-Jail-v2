import { useLocalState } from '../../backend';
import { Button, Icon, Input, Section, Stack, Tabs } from '../../components';
import {
  CharacterPrefsTab,
  ContentPreferencesTab,
  GenitalTab,
  InteractionsTab,
  LewdItemsTab,
} from './tabs';

export const MainContent = () => {
  const [searchText, setSearchText] = useLocalState('searchText', '');
  const [tabIndex, setTabIndex] = useLocalState('tabIndex', 0);
  const [inFavorites, setInFavorites] = useLocalState('inFavorites', false);

  return (
    <Section fill>
      <Stack vertical fill>
        <Stack.Item>
          <Tabs fluid textAlign="center">
            <Tabs.Tab
              selected={tabIndex === 0}
              onClick={() => setTabIndex(0)}
              rightSlot={
                <Button
                  icon={inFavorites ? 'star' : 'star-o'}
                  color="transparent"
                  onClick={() => setInFavorites(!inFavorites)}
                  tooltip={`Click here to ${inFavorites ? 'show all' : 'show favorites'}`}
                />
              }
            >
              Interactions
            </Tabs.Tab>
            <Tabs.Tab selected={tabIndex === 1} onClick={() => setTabIndex(1)}>
              Genital Options
            </Tabs.Tab>
            <Tabs.Tab selected={tabIndex === 2} onClick={() => setTabIndex(2)}>
              Character Prefs
            </Tabs.Tab>
            <Tabs.Tab selected={tabIndex === 3} onClick={() => setTabIndex(3)}>
              Content Prefs
            </Tabs.Tab>
            <Tabs.Tab selected={tabIndex === 4} onClick={() => setTabIndex(4)}>
              Lewd Items
            </Tabs.Tab>
          </Tabs>
        </Stack.Item>
        <Stack.Item>
          <Stack align="baseline" fill>
            <Stack.Item>
              <Icon name="search" />
            </Stack.Item>
            <Stack.Item grow>
              <Input
                fluid
                placeholder={
                  tabIndex === 0
                    ? 'Search for an interaction'
                    : tabIndex === 1
                      ? 'Search for a genital'
                      : tabIndex === 3
                        ? 'Search for a content preference'
                        : tabIndex === 4
                          ? 'Search for an item'
                          : 'Searching is unavailable for this tab'
                }
                onInput={(e, value) => setSearchText(value)}
              />
            </Stack.Item>
          </Stack>
        </Stack.Item>
        <Stack.Item grow basis={0} mb={-2.3}>
          <Section scrollable fill>
            {(() => {
              switch (tabIndex) {
                case 1:
                  return <GenitalTab />;
                case 2:
                  return <CharacterPrefsTab />;
                case 3:
                  return <ContentPreferencesTab />;
                case 4:
                  return <LewdItemsTab />;
                default:
                  return <InteractionsTab />;
              }
            })()}
          </Section>
        </Stack.Item>
      </Stack>
    </Section>
  );
};
