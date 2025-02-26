import { useBackend } from '../backend';
import { useState, useEffect } from 'react';
import {
  Button,
  Section,
  Tabs,
  NumberInput,
  Box,
  Icon,
  Table,
  NoticeBox,
} from '../components';
import { Window } from '../layouts';

const OpenRooms = ({ data, act, selected_template }) => {
  return (
    <Section
      title="Open Rooms"
      style={{
        paddingBottom: '0px',
      }}
    >
      <Box
        style={{
          height: '100%',
          overflowY: 'auto',
          width: '100%',
        }}
      >
        <Table>
          {data.active_rooms?.map((room) => (
            <Table.Row
              key={room.number}
              style={{
                padding: '4px 4px',
                backgroundColor: 'rgba(138, 138, 138, 0.1)',
              }}
            >
              <Table.Cell
                style={{
                  padding: '5px 5px',
                  verticalAlign: 'top',
                  marginLeft: '0px',
                  marginRight: 'auto',
                }}
              >
                <Box
                  style={{
                    fontSize: '20px',
                    width: '100px',
                    textAlign: 'center',
                    backgroundColor: 'rgb(0, 0, 0)',
                    border: '2px solid rgb(53, 118, 172)',
                    borderRadius: '3px',
                    marginBottom: '5px',
                    color: 'rgb(115, 177, 228)',
                    padding: '0px 0px',
                  }}
                >
                  {room.number}
                </Box>
                <Button.Confirm
                  style={{
                    cursor: 'pointer',
                    width: '100px',
                    textAlign: 'center',
                  }}
                  confirmContent={'Join?'}
                  confirmColor="green"
                  onClick={() =>
                    act('checkin', {
                      room: room.number,
                      template: selected_template,
                    })
                  }
                >
                  <Icon name="right-to-bracket" />
                  Join
                </Button.Confirm>
              </Table.Cell>
              <Table.Cell
                style={{
                  textAlign: 'left',
                  width: '100%',
                }}
              >
                <Box>
                  <Box
                    style={{
                      fontSize: '18px',
                      lineHeight: '1.4',
                      padding: '0px 3px',
                      marginBottom: '2px',
                    }}
                  >
                    <Box
                      style={{
                        display: 'flex',
                        alignItems: 'center',
                        padding: '2px 0px',
                      }}
                    >
                      <span>{room.name}</span>
                      <Box
                        style={{
                          fontSize: '10px',
                          marginLeft: '10px',
                        }}
                      >
                        <Icon name="users" /> {room.occupants.length}
                      </Box>
                    </Box>
                    <Box
                      style={{
                        color: 'rgba(255, 255, 255, 0.7)',
                        fontSize: '12px',
                        lineHeight: '1.4',
                        wordWrap: 'break-word',
                        overflowWrap: 'break-word',
                        maxWidth: '400px',
                        marginBottom: '5px',
                      }}
                    >
                      {room.description ? (
                        room.description
                      ) : (
                        <i>No description</i>
                      )}
                    </Box>
                  </Box>
                </Box>
              </Table.Cell>
            </Table.Row>
          ))}
        </Table>
      </Box>
    </Section>
  );
};

const RoomCheckIn = ({
  data,
  act,
  selectedTab,
  setSelectedTab,
  tabContent,
}) => {
  const { current_room = 1, selected_template = 'Standard' } = data;
  return (
    <Section title="Room Check-In">
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
            maxValue={1000000000}
            step={1}
            value={current_room}
            format={(value) => Math.floor(value)}
            onDrag={(value) =>
              act('update_room', {
                room: value,
              })
            }
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
            onClick={() =>
              act('checkin', {
                room: current_room,
                template: selected_template,
              })
            }
            lineHeight={2}
          >
            <Icon name="right-to-bracket" />
            Check-in
          </Button.Confirm>
        </div>
      </div>
    </Section>
  );
};

const ReservedRooms = ({ data }) => {
  return (
    <Section title="Reserved Rooms">
      <Table>
        {data.conservated_rooms?.map((room) => (
          <Table.Row key={room.number}>
            <Table.Cell>Room {room.number}</Table.Cell>
            <Table.Cell>
              {room.description ? room.description : <i>No description</i>}
            </Table.Cell>
          </Table.Row>
        ))}
      </Table>
    </Section>
  );
};

export const CheckoutMenu = (props) => {
  const { act, data } = useBackend();
  const [selectedTab, setSelectedTab] = useState(0);
  const tabContent = [
    <RoomsTab category="Misc" selected_template={data.selected_template} />,
    <RoomsTab
      category="Apartment"
      selected_template={data.selected_template}
    />,
    <RoomsTab category="Beach" selected_template={data.selected_template} />,
    <RoomsTab category="Station" selected_template={data.selected_template} />,
    <RoomsTab category="Winter" selected_template={data.selected_template} />,
    <RoomsTab category="Special" selected_template={data.selected_template} />,
  ];

  return (
    <Box>
      <RoomCheckIn
        data={data}
        act={act}
        selectedTab={selectedTab}
        setSelectedTab={setSelectedTab}
        tabContent={tabContent}
      />
      <OpenRooms
        data={data}
        act={act}
        selected_template={data.selected_template}
      />
      <ReservedRooms data={data} />
    </Box>
  );
};

const RoomsTab = (props) => {
  const { category, selected_template } = props;
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
        height: '100%',
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
            className={room.name === selected_template ? 'selected' : undefined}
            onClick={() => {
              setSelectedRoom(room.name);
              act('select_room', { room: room.name });
            }}
            style={{
              lineHeight: '2.5',
              cursor: 'pointer',
              transition: 'background-color 0.2s',
              padding: '4px 4px',
              borderRadius: '4px',
              backgroundColor:
                room.name === selected_template
                  ? 'rgba(159, 236, 163, 0.1)'
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

export const HilbertsHotelCheckout = (props) => {
  const { act, data } = useBackend();

  return (
    <Window width={600} height={600} title="Dr. Hilbert's Hotel Room Reception">
      <Window.Content>
        <CheckoutMenu />
      </Window.Content>
    </Window>
  );
};
