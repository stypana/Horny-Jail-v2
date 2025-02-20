import { useBackend } from '../backend';
import { useState, useEffect } from 'react';
import {
  AnimatedNumber,
  Button,
  ProgressBar,
  Section,
  Tabs,
  NumberInput,
  Box,
  Icon,
  Table,
  NoticeBox,
} from '../components';
import { Window } from '../layouts';

export const HilbertsHotelCheckout = (props) => {
  const { act, data } = useBackend();
  const { current_room } = data;
  const [selectedTab, setSelectedTab] = useState(0);
  const [roomNumber, setRoomNumber] = useState(current_room || 1);

  const handleNumberChange = (value) => {
    const num = Math.floor(Number(value));
    if (isNaN(num) || num < 1 || num > 100000) return;
    setRoomNumber(num);
  };

  useEffect(() => {
    act('update_room', { room: roomNumber });
  }, [roomNumber, act]);

  const tabContent = [
    <RoomsTab category="Misc" />,
    <RoomsTab category="Apartment" />,
    <RoomsTab category="Beach" />,
    <RoomsTab category="Station" />,
    <RoomsTab category="Winter" />,
    <RoomsTab category="Special" />,
  ];

  return (
    <Window width={600} height={400} title="Dr. Hilbert's Hotel Room Reception">
      <Window.Content>
        <Section title="Room Checkout">
          <div style={{ display: 'flex', gap: '1rem' }}>
            <div style={{ flexGrow: 1, maxWidth: 600 }}>
              <Tabs>
                <Tabs.Tab
                  key={0}
                  selected={selectedTab === 0}
                  onClick={() => setSelectedTab(0)}
                  style={{ cursor: 'pointer' }}
                >
                  <Icon name="shuffle" /> Misc
                </Tabs.Tab>
                <Tabs.Tab
                  key={1}
                  selected={selectedTab === 1}
                  onClick={() => setSelectedTab(1)}
                  style={{ cursor: 'pointer' }}
                >
                  <Icon name="building" /> Apartment
                </Tabs.Tab>
                <Tabs.Tab
                  key={2}
                  selected={selectedTab === 2}
                  onClick={() => setSelectedTab(2)}
                  style={{ cursor: 'pointer' }}
                >
                  <Icon name="umbrella-beach" /> Beach
                </Tabs.Tab>
                <Tabs.Tab
                  key={3}
                  selected={selectedTab === 3}
                  onClick={() => setSelectedTab(3)}
                  style={{ cursor: 'pointer' }}
                >
                  <Icon name="satellite" /> Station
                </Tabs.Tab>
                <Tabs.Tab
                  key={4}
                  selected={selectedTab === 4}
                  onClick={() => setSelectedTab(4)}
                  style={{ cursor: 'pointer' }}
                >
                  <Icon name="snowflake" /> Winter
                </Tabs.Tab>
                <Tabs.Tab
                  key={5}
                  selected={selectedTab === 5}
                  onClick={() => setSelectedTab(5)}
                  style={{ cursor: 'pointer' }}
                >
                  <Icon name="heart" /> Special
                </Tabs.Tab>
              </Tabs>
              <Box mt={2}>{tabContent[selectedTab]}</Box>
            </div>

            <div style={{ width: '100px' }}>
              <NumberInput
                width="100%"
                minValue={1}
                maxValue={100000}
                step={1}
                value={roomNumber}
                onChange={(e, value) => handleNumberChange(value)}
                lineHeight={1.8}
                fontSize="20px"
              />
              <Button.Confirm
                style={{ cursor: 'pointer' }}
                width="100%"
                fluid
                textAlign="center"
                mt={1}
                confirmContent={'Confirm?'}
                onClick={() => act('checkout', { room: roomNumber })}
                my={1}
                lineHeight={2}
              >
                <Icon name="right-to-bracket" />
                Checkout
              </Button.Confirm>
            </div>
          </div>
        </Section>

        <Section title="Open Rooms">
          <p>Rooms Content :p</p>
        </Section>
      </Window.Content>
    </Window>
  );
};

const RoomsTab = (props) => {
  const { category } = props;
  const { act, data } = useBackend();
  const { hotel_map_list = [] } = data;
  const [selectedRoom, setSelectedRoom] = useState(null);

  const targetCategory = category.toLowerCase();
  const filteredRooms = hotel_map_list.filter(
    (room) => room.category?.toLowerCase() === targetCategory,
  );

  // Иконки для категорий
  const categoryIcons = {
    apartment: 'building',
    beach: 'umbrella-beach',
    station: 'satellite',
    winter: 'snowflake',
    special: 'heart',
    misc: 'shuffle',
  };

  return (
    <Box
      style={{
        height: 'fit-content',
        overflowY: 'auto',
        width: '100%',
      }}
    >
      <Table width="95%">
        {filteredRooms.length === 0 && (
          <NoticeBox>No {category} rooms found!</NoticeBox>
        )}
        {filteredRooms.map((room) => (
          <Table.Row
            width="fit-content"
            key={room.name}
            className={selectedRoom === room.name ? 'selected' : undefined}
            onClick={() => {
              setSelectedRoom(room.name);
              act('select_room', { room: room.name });
            }}
            style={{
              lineHeight: '2.2',
              cursor: 'pointer',
              transition: 'background-color 0.2s',
              padding: '4px 8px',
              backgroundColor:
                selectedRoom === room.name
                  ? 'rgba(255, 255, 255, 0.1)'
                  : 'transparent',
            }}
          >
            <Table.Cell collapsing width="25px">
              <Icon
                name={
                  categoryIcons[room.category?.toLowerCase()] || 'door-open'
                }
                mr={2}
                style={{ marginLeft: '10px' }}
              />
            </Table.Cell>
            <Table.Cell>{room.name}</Table.Cell>
          </Table.Row>
        ))}
      </Table>
    </Box>
  );
};
