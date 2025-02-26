import { useBackend } from '../../backend';
import { Button, Section, Stack, TextArea } from '../../components';
import { Window } from '../../layouts';

type RoomData = {
  visibility: number;
  status: number;
  privacy: number;
  description: string;
};

export const HilbertsHotelRoomControl = (props) => {
  const { act, data } = useBackend<RoomData>();

  return (
    <Window width={400} height={300} title="Room Control Panel">
      <Window.Content>
        <Section>
          <Stack vertical>
            <Stack.Item>
              <Button
                fluid
                icon={data.visibility ? 'eye' : 'eye-slash'}
                onClick={() => act('toggle_visibility')}
              >
                {data.visibility ? 'Room Visible' : 'Room Hidden'}
              </Button>
            </Stack.Item>
            <Stack.Item>
              <Button
                fluid
                icon={data.status ? 'lock-open' : 'lock'}
                onClick={() => act('toggle_status')}
              >
                {data.status ? 'Room Open' : 'Room Closed'}
              </Button>
            </Stack.Item>
            <Stack.Item>
              <Button
                fluid
                icon={data.privacy ? 'users' : 'user-secret'}
                onClick={() => act('toggle_privacy')}
              >
                {data.privacy ? 'Guests Visible' : 'Guests Hidden'}
              </Button>
            </Stack.Item>
            <Stack.Item>
              <TextArea
                fluid
                height="4em"
                placeholder="Room description..."
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
                Update Description
              </Button>
            </Stack.Item>
          </Stack>
        </Section>
      </Window.Content>
    </Window>
  );
};
