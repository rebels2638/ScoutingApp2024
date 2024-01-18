import { createSlice } from "@reduxjs/toolkit";

export const dataSlice = createSlice({
	name: "dataSlice",
	initialState: {
		keyPairValues: {},
		default: {},
		blendedState: {} // https://github.com/rebels2638/ScoutingApp2022/issues/18
	},
	reducers: {
		setKeyPair: (state, action) => {
			// so many annoying checks
			if (!(action.payload instanceof Array))		console.log("WARNING! Expected key-value array");
			if (typeof action.payload[0] !== "string")	console.log("WARNING! Expected key to be string.");
			if (action.payload.length !== 2)			console.log("WARNING! Expected key-value array to have two items.");

			// key-values are stored in the payload in the format [key, value]
			const [key, value] = action.payload;

			state.keyPairValues[key] = value;
		},

		setDefault: (state, action) => {
			if (!(action.payload instanceof Array))		console.log(`WARNING! Expected key-value array, instead got ${typeof action.payload}.`);
			if (typeof action.payload[0] !== "string")	console.log(`WARNING! Expected key to be string, instead got ${typeof action.paylod[0]}.`);
			if (action.payload.length !== 2)			console.log("WARNING! Expected key-value array to have two items.");

			const [key, value] = action.payload;

			if (!(key in state.keyPairValues)) {
				state.keyPairValues[key] = value;
			}

			state.default[key] = value;

			if (!(key in state.blendedState)) {
				state.blendedState[key] = null;
			}
		},

		loadMatch: (state, action) => {
			// should only be used when clicking on a match in Past Matches
			// import that bad boy
			console.log("A match has been loaded.");
			state.keyPairValues = action.payload;
			
			// NOTE: loadMatch does not have a whitelist
			state.blendedState = action.payload;
		},

		freshStart: (state) => {
			/**
			 * wipe the slate clean
			 * commit magnet on hard-drive
			 * 
			 * Amnesia, by 5SOS: https://open.spotify.com/track/1JCCdiru7fhstOIF4N7WJC
			 **/

			// if you couldn't tell, this erases everything but info
			// whitelist vals not to remove
			const whitelist = ["Team", "Scouters", "MatchType", "MatchNumber", "TeamNumber", "StartingPosition", "ThemeSelector"];

			for (let key in state.keyPairValues) {
				if (!whitelist.includes(key)) {
					state.keyPairValues[key] = state.default[key];
					state.blendedState[key] = state.default[key];
				}
			}
		},

		// https://open.spotify.com/track/3m9lnuSYZmHsopPycNnGqM
		// hehehe consume CON SUME consumi
		consumeBlend: (state, action) => {
			// key should be a string
			const key = action.payload;

			if (typeof key !== "string") console.log(`WARNING! Expected key, instead got ${typeof key}.`);

			state.blendedState[key] = null;
		}
	},
});

export const { setKeyPair, setDefault, loadMatch, freshStart, consumeBlend } = dataSlice.actions;
window.skp = dataSlice.actions.setKeyPair;

// The function below is called a selector and allows us to select a value from
// the state. Selectors can also be defined inline where they're used instead of
// in the slice file. For example: `useSelector((state) => state.counter.value)`
export const selectData = state => state.data.keyPairValues;
// yeah these are big brain hours
export const selectID = id => state => state.data.keyPairValues[id];
export const selectBlendedID = id => state => state.data.blendedState[id];

export default dataSlice.reducer;
