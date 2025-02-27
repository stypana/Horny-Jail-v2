import { useBackend, useLocalState } from '../backend';
import {
  Box,
  Button,
  Grid,
  Icon,
  Modal,
  Section,
  Stack,
  TextArea,
  Tooltip,
  LabeledList,
} from '../components';
import { Window } from '../layouts';

type RoomData = {
  visibility: number;
  status: number;
  privacy: number;
  description: string;
  name: string;
  room_number: number;
  icon: string;
  bluespace_box?: number;
  id_card: number;
};

const AVAILABLE_ICONS = [
  'snowflake',
  'bed',
  'coffee',
  'glass-water',
  'burger',
  'dice',
  'gamepad',
  'heart',
  'music',
  'palette',
  'book',
  'dumbbell',
  'skull',
  'ghost',
] as const;

export const HilbertsHotelRoomControl = (props) => {
  const { act, data } = useBackend<RoomData>();
  const [iconPickerOpen, setIconPickerOpen] = useLocalState(
    'iconPicker',
    false,
  );
  const [departureModalOpen, setDepartureModalOpen] = useLocalState(
    'departure',
    false,
  );

  return (
    <Window width={400} height={500} title="Room Control Panel">
      {!!iconPickerOpen && (
        <Modal
          style={{
            width: '280px',
            padding: '5px',
          }}
        >
          <Section>
            <Box
              style={{
                display: 'grid',
                gridTemplateColumns: 'repeat(4, 1fr)',
                gap: '4px',
                padding: '4px',
              }}
            >
              {AVAILABLE_ICONS.map((icon) => (
                <Button
                  key={icon}
                  onClick={() => {
                    act('set_icon', { icon });
                    setIconPickerOpen(false);
                  }}
                  style={{
                    height: '32px',
                    width: '32px',
                    padding: '3px 8px',
                    lineHeight: '32px',
                    cursor: 'pointer',
                  }}
                >
                  <Icon name={icon} size={1.5} />
                </Button>
              ))}
            </Box>
          </Section>
        </Modal>
      )}
      {!!iconPickerOpen && (
        <Modal
          style={{
            width: '280px',
            padding: '5px',
          }}
        >
          <Section>
            <Box
              style={{
                display: 'grid',
                gridTemplateColumns: 'repeat(4, 1fr)',
                gap: '4px',
                padding: '4px',
              }}
            >
              {AVAILABLE_ICONS.map((icon) => (
                <Button
                  key={icon}
                  onClick={() => {
                    act('set_icon', { icon });
                    setIconPickerOpen(false);
                  }}
                  style={{
                    height: '32px',
                    width: '32px',
                    padding: '3px 8px',
                    lineHeight: '32px',
                    cursor: 'pointer',
                  }}
                >
                  <Icon name={icon} size={1.5} />
                </Button>
              ))}
            </Box>
          </Section>
        </Modal>
      )}
      {!!departureModalOpen && (
        <Modal
          style={{
            width: '280px',
            padding: '5px',
          }}
        >
          <Section title="Confirm Departure">
            <Stack vertical>
              <Stack.Item>
                Departing will consume your ID card and open your job slot, as
                if you've entered cryosleep stasis. Items you put in the box
                will be returned to the cryogenic oversight console.
              </Stack.Item>
              <Stack.Item>
                <Stack justify="space-between">
                  <Stack.Item>
                    <Button
                      icon="check"
                      color="good"
                      onClick={() => {
                        act('depart');
                        setDepartureModalOpen(false);
                      }}
                    >
                      Confirm
                    </Button>
                  </Stack.Item>
                  <Stack.Item>
                    <Button
                      icon="times"
                      color="bad"
                      onClick={() => setDepartureModalOpen(false)}
                    >
                      Cancel
                    </Button>
                  </Stack.Item>
                </Stack>
              </Stack.Item>
            </Stack>
          </Section>
        </Modal>
      )}
      <Window.Content>
        <Section>
          <Stack>
            <Stack.Item
              style={{
                fontSize: '20px',
                textAlign: 'center',
                backgroundColor: 'rgb(0, 0, 0)',
                border: '2px solid rgb(53, 118, 172)',
                borderRadius: '3px',
                color: 'rgb(115, 177, 228)',
                padding: '2px 5px',
              }}
            >
              {data.room_number || '69'}
            </Stack.Item>
            <Stack vertical>
              <Stack.Item
                style={{
                  marginLeft: '10px',
                  fontSize: '8',
                  color: 'rgb(179, 179, 179)',
                  fontStyle: 'italic',
                }}
              >
                You're currently in...
              </Stack.Item>
              <Stack.Item
                style={{
                  fontSize: '18px',
                  lineHeight: '0.8',
                  marginLeft: '10px',
                  marginTop: '1px',
                }}
              >
                {data.name || 'Custom Room'}
              </Stack.Item>
            </Stack>
            <Stack.Item ml="auto" mr="2px">
              <Tooltip content="Icon picker">
                <Button
                  onClick={() => setIconPickerOpen(true)}
                  style={{
                    height: '30px',
                    width: '32px',
                    cursor: 'pointer',
                    padding: '6px 8px',
                    marginTop: '1px',
                    marginRight: '1px',
                  }}
                >
                  <Icon size={1.5} name={data.icon || 'snowflake'} />
                </Button>
              </Tooltip>
            </Stack.Item>
          </Stack>
        </Section>
        <Section title="Room Status">
          <Stack vertical>
            <Stack fill textAlign="center">
              <Stack.Item grow>
                <Button
                  fluid
                  icon={data.visibility ? 'eye' : 'eye-slash'}
                  onClick={() => act('toggle_visibility')}
                  lineHeight="2.2"
                  color="green"
                >
                  {data.visibility ? 'Room visible' : 'Room hidden'}
                </Button>
              </Stack.Item>
              <Stack.Item grow>
                <Button
                  fluid
                  icon={data.status ? 'lock-open' : 'lock'}
                  onClick={() => act('toggle_status')}
                  lineHeight="2.2"
                  color="green"
                >
                  {data.status ? 'Room open' : 'Room closed'}
                </Button>
              </Stack.Item>
              <Stack.Item grow>
                <Button
                  fluid
                  icon={data.privacy ? 'users' : 'user-secret'}
                  onClick={() => act('toggle_privacy')}
                  lineHeight="2.2"
                  color="green"
                >
                  {data.privacy ? 'Guests visible' : 'Guests hidden'}
                </Button>
              </Stack.Item>
            </Stack>
            <Stack mt="6px">
              <Stack.Item width="100%">
                <TextArea
                  fluid
                  height="1.7em"
                  width="100%"
                  placeholder="Enter room name here..."
                  value={data.name || ''}
                  onChange={(e, value) =>
                    act('update_name', {
                      name: value,
                    })
                  }
                />
              </Stack.Item>
              <Stack.Item>
                <Button.Confirm
                  fluid
                  icon="check"
                  onClick={() => act('confirm_name')}
                  style={{
                    cursor: 'pointer',
                    height: '1.7em',
                    width: '1.85em',
                  }}
                  confirmContent={<Icon name="question"></Icon>}
                ></Button.Confirm>
              </Stack.Item>
            </Stack>
            <Stack.Item>
              <TextArea
                fluid
                style={{
                  width: '100%',
                  height: '4em',
                }}
                placeholder="Enter room description here..."
                value={data.description || ''}
                onChange={(e, value) =>
                  act('update_description', {
                    description: value,
                  })
                }
              />
            </Stack.Item>
            <Stack.Item>
              <Button
                fluid
                icon="check"
                onClick={() => act('confirm_description')}
              >
                Update description
              </Button>
            </Stack.Item>
          </Stack>
        </Section>
        <Section title="Departure">
          <Stack vertical>
            <Stack.Item
              style={{
                width: '100%',
                height: 'fit-content',
                padding: '2px 2px',
                backgroundColor: 'rgb(36, 36, 36)',
              }}
            >
              {data.id_card ? (
                <Button
                  fluid
                  icon="eject"
                  onClick={() => act('eject_id')}
                  lineHeight="2"
                >
                  test
                </Button>
              ) : (
                <i
                  style={{
                    lineHeight: '2',
                    marginLeft: '4px',
                    color: 'rgb(128, 128, 128)',
                  }}
                >
                  No ID card present.
                </i>
              )}
            </Stack.Item>
            <Stack.Item
              style={{
                width: '100%',
                height: 'fit-content',
                padding: '5px 5px',
                backgroundColor: 'rgb(36, 36, 36)',
              }}
            >
              <Button
                fluid
                icon="eject"
                onClick={() => act('eject_id')}
                lineHeight="2"
              >
                Bluespace Storage
              </Button>
            </Stack.Item>
            <Stack.Item>
              <Button
                fluid
                icon="sign-out-alt"
                onClick={() => setDepartureModalOpen(true)}
                lineHeight="2"
              >
                Depart
              </Button>
            </Stack.Item>
          </Stack>
        </Section>
      </Window.Content>
    </Window>
  );
};
