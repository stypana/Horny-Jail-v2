import { useBackend } from '../../../backend';
import { Button, Stack } from '../../../components';

type ContentPrefsInfo = {
  verb_consent: boolean;
  lewd_verb_sounds: boolean;
  arousable: boolean;
  genital_examine: boolean;
  vore_examine: boolean;
  medihound_sleeper: boolean;
  eating_noises: boolean;
  digestion_noises: boolean;
  trash_forcefeed: boolean;
  forced_fem: boolean;
  forced_masc: boolean;
  hypno: boolean;
  bimbofication: boolean;
  breast_enlargement: boolean;
  penis_enlargement: boolean;
  butt_enlargement: boolean;
  belly_inflation: boolean;
  never_hypno: boolean;
  no_aphro: boolean;
  no_ass_slap: boolean;
  no_auto_wag: boolean;
  chastity_pref: boolean;
  stimulation_pref: boolean;
  edging_pref: boolean;
  cum_onto_pref: boolean;
};

export const ContentPreferencesTab = () => {
  const { act, data } = useBackend<ContentPrefsInfo>();
  const {
    verb_consent,
    lewd_verb_sounds,
    arousable,
    genital_examine,
    vore_examine,
    medihound_sleeper,
    eating_noises,
    digestion_noises,
    trash_forcefeed,
    forced_fem,
    forced_masc,
    hypno,
    bimbofication,
    breast_enlargement,
    penis_enlargement,
    butt_enlargement,
    belly_inflation,
    never_hypno,
    no_aphro,
    no_ass_slap,
    no_auto_wag,
    chastity_pref,
    stimulation_pref,
    edging_pref,
    cum_onto_pref,
  } = data;
  return (
    <Stack vertical fill>
      <Stack.Item>
        <Button
          fluid
          mb={-0.7}
          icon={verb_consent ? 'toggle-on' : 'toggle-off'}
          selected={verb_consent}
          onClick={() =>
            act('pref', {
              pref: 'verb_consent',
            })
          }
        >
          Allow lewd verbs
        </Button>
      </Stack.Item>
      <Stack.Item>
        <Button
          fluid
          mb={-0.7}
          icon={lewd_verb_sounds ? 'volume-up' : 'volume-mute'}
          selected={lewd_verb_sounds}
          onClick={() =>
            act('pref', {
              pref: 'lewd_verb_sounds',
            })
          }
        >
          Lewd verb sounds
        </Button>
      </Stack.Item>
      <Stack.Item>
        <Button
          fluid
          mb={-0.7}
          icon={arousable ? 'toggle-on' : 'toggle-off'}
          selected={arousable}
          onClick={() =>
            act('pref', {
              pref: 'arousable',
            })
          }
        >
          Arousal
        </Button>
      </Stack.Item>
      <Stack.Item>
        <Button
          fluid
          mb={-0.7}
          icon={genital_examine ? 'toggle-on' : 'toggle-off'}
          selected={genital_examine}
          onClick={() =>
            act('pref', {
              pref: 'genital_examine',
            })
          }
        >
          Genital examine text
        </Button>
      </Stack.Item>
      <Stack.Item>
        <Button
          fluid
          mb={-0.7}
          icon={vore_examine ? 'toggle-on' : 'toggle-off'}
          selected={vore_examine}
          onClick={() =>
            act('pref', {
              pref: 'vore_examine',
            })
          }
        >
          Vore examine text
        </Button>
      </Stack.Item>
      <Stack.Item>
        <Button
          fluid
          mb={-0.7}
          icon={medihound_sleeper ? 'toggle-on' : 'toggle-off'}
          selected={medihound_sleeper}
          onClick={() =>
            act('pref', {
              pref: 'medihound_sleeper',
            })
          }
        >
          Voracious Medihound sleepers
        </Button>
      </Stack.Item>
      <Stack.Item>
        <Button
          fluid
          mb={-0.7}
          icon={eating_noises ? 'volume-up' : 'volume-mute'}
          selected={eating_noises}
          onClick={() =>
            act('pref', {
              pref: 'eating_noises',
            })
          }
        >
          Hear vore sounds
        </Button>
      </Stack.Item>
      <Stack.Item>
        <Button
          fluid
          mb={-0.7}
          icon={digestion_noises ? 'volume-up' : 'volume-mute'}
          selected={digestion_noises}
          onClick={() =>
            act('pref', {
              pref: 'digestion_noises',
            })
          }
        >
          Hear vore digestion sounds
        </Button>
      </Stack.Item>
      <Stack.Item>
        <Button
          fluid
          mb={-0.7}
          icon={trash_forcefeed ? 'toggle-on' : 'toggle-off'}
          selected={trash_forcefeed}
          onClick={() =>
            act('pref', {
              pref: 'trash_forcefeed',
            })
          }
        >
          Allow trash forcefeeding (requires Trashcan quirk)
        </Button>
      </Stack.Item>
      <Stack.Item>
        <Button
          fluid
          mb={-0.7}
          icon={forced_fem ? 'toggle-on' : 'toggle-off'}
          selected={forced_fem}
          onClick={() =>
            act('pref', {
              pref: 'forced_fem',
            })
          }
        >
          Forced feminization
        </Button>
      </Stack.Item>
      <Stack.Item>
        <Button
          fluid
          mb={-0.7}
          icon={forced_masc ? 'toggle-on' : 'toggle-off'}
          selected={forced_masc}
          onClick={() =>
            act('pref', {
              pref: 'forced_masc',
            })
          }
        >
          Forced Masculinization
        </Button>
      </Stack.Item>
      <Stack.Item>
        <Button
          fluid
          mb={-0.7}
          icon={hypno ? 'toggle-on' : 'toggle-off'}
          selected={hypno}
          onClick={() =>
            act('pref', {
              pref: 'hypno',
            })
          }
        >
          Lewd hypno
        </Button>
      </Stack.Item>
      <Stack.Item>
        <Button
          fluid
          mb={-0.7}
          icon={bimbofication ? 'toggle-on' : 'toggle-off'}
          selected={bimbofication}
          onClick={() =>
            act('pref', {
              pref: 'bimbofication',
            })
          }
        >
          Bimbofication
        </Button>
      </Stack.Item>
      <Stack.Item>
        <Button
          fluid
          mb={-0.7}
          icon={breast_enlargement ? 'toggle-on' : 'toggle-off'}
          selected={breast_enlargement}
          onClick={() =>
            act('pref', {
              pref: 'breast_enlargement',
            })
          }
        >
          Breast enlargement
        </Button>
      </Stack.Item>
      <Stack.Item>
        <Button
          fluid
          mb={-0.7}
          icon={penis_enlargement ? 'toggle-on' : 'toggle-off'}
          selected={penis_enlargement}
          onClick={() =>
            act('pref', {
              pref: 'penis_enlargement',
            })
          }
        >
          Penis enlargement
        </Button>
      </Stack.Item>
      <Stack.Item>
        <Button
          fluid
          mb={-0.7}
          icon={butt_enlargement ? 'toggle-on' : 'toggle-off'}
          selected={butt_enlargement}
          onClick={() =>
            act('pref', {
              pref: 'butt_enlargement',
            })
          }
        >
          Butt enlargement
        </Button>
      </Stack.Item>
      <Stack.Item>
        <Button
          fluid
          mb={-0.7}
          icon={belly_inflation ? 'toggle-on' : 'toggle-off'}
          selected={belly_inflation}
          onClick={() =>
            act('pref', {
              pref: 'belly_inflation',
            })
          }
        >
          Belly inflation
        </Button>
      </Stack.Item>
      <Stack.Item>
        <Button
          fluid
          mb={-0.7}
          icon={never_hypno ? 'toggle-on' : 'toggle-off'}
          selected={never_hypno}
          onClick={() =>
            act('pref', {
              pref: 'never_hypno',
            })
          }
        >
          Never hypno
        </Button>
      </Stack.Item>
      <Stack.Item>
        <Button
          fluid
          mb={-0.7}
          icon={no_aphro ? 'toggle-on' : 'toggle-off'}
          selected={no_aphro}
          onClick={() =>
            act('pref', {
              pref: 'no_aphro',
            })
          }
        >
          No aphrodisiacs
        </Button>
      </Stack.Item>
      <Stack.Item>
        <Button
          fluid
          mb={-0.7}
          icon={no_ass_slap ? 'toggle-on' : 'toggle-off'}
          selected={no_ass_slap}
          onClick={() =>
            act('pref', {
              pref: 'no_ass_slap',
            })
          }
        >
          No ass slapping
        </Button>
      </Stack.Item>
      <Stack.Item>
        <Button
          fluid
          mb={-0.7}
          icon={no_auto_wag ? 'toggle-on' : 'toggle-off'}
          selected={no_auto_wag}
          onClick={() =>
            act('pref', {
              pref: 'no_auto_wag',
            })
          }
        >
          No automatic wagging
        </Button>
      </Stack.Item>
      <Stack.Item>
        <Button
          fluid
          mb={-0.7}
          icon={chastity_pref ? 'toggle-on' : 'toggle-off'}
          selected={chastity_pref}
          onClick={() =>
            act('pref', {
              pref: 'chastity_pref',
            })
          }
        >
          Allow chastity
        </Button>
      </Stack.Item>
      <Stack.Item>
        <Button
          fluid
          mb={-0.7}
          icon={stimulation_pref ? 'toggle-on' : 'toggle-off'}
          selected={stimulation_pref}
          onClick={() =>
            act('pref', {
              pref: 'stimulation_pref',
            })
          }
        >
          Allow stimulation
        </Button>
      </Stack.Item>
      <Stack.Item>
        <Button
          fluid
          mb={-0.7}
          icon={edging_pref ? 'toggle-on' : 'toggle-off'}
          selected={edging_pref}
          onClick={() =>
            act('pref', {
              pref: 'edging_pref',
            })
          }
        >
          Allow edging
        </Button>
      </Stack.Item>
      <Stack.Item>
        <Button
          fluid
          mb={-0.7}
          icon={cum_onto_pref ? 'toggle-on' : 'toggle-off'}
          selected={cum_onto_pref}
          onClick={() =>
            act('pref', {
              pref: 'cum_onto_pref',
            })
          }
        >
          Allow being cummed on
        </Button>
      </Stack.Item>
    </Stack>
  );
};
