import { createSlice } from "@reduxjs/toolkit";

export const matchSlice = createSlice({
	name: "matchSlice",
	initialState: {
		matches: [],
		selectedMatches: {}
	},
	reducers: {
		writeMatch: (state, action) => {
			// action is in format
			// [key, payload]
			const [matchKey, kpv] = action.payload;

			if (!(typeof matchKey === "string"))					console.log(`WARNING! Expected key to be string, instead got ${typeof matchKey}.`);
			if (!(kpv instanceof Object))							console.log(`WARNING! Expected match to be an object, instead got ${typeof kpv}.`);

			const mki = state.matches.findIndex(v => v && (v[0] === matchKey));

			if (mki === -1) {
				// if the match key is not found
				// push
				state.matches.push(action.payload);
			} else {
				// if the match key IS found
				// overwrite
				state.matches[mki] = action.payload;
			}
		},

		importMatches: (state, action) => {
			// should only be used when the app starts
			// import that bad boy
			state.matches = action.payload;
		},

		deleteSingleMatch: (state, action) => {
			const matchKey = action.payload;
			const mki = state.matches.findIndex(v => v && (v[0] === matchKey));
			state.matches.splice(mki, 1);
		},

		deleteMatches: (state) => {
			const selectedMatchKeys = Object.keys(state.selectedMatches);
			// check if selectedMatches is empty. if so,
			if (selectedMatchKeys.length === 0) {
				// resets ALL the matches
				state.matches = [];
			} else {
				// otherwise only reset the selected matches, clear selectedMatches
				state.matches = state.matches.filter(([matchKey]) => !selectedMatchKeys.includes(matchKey));
				state.selectedMatches = {};
			}
		},

		toggleSelectMatch: (state, action) => {
			const matchKey = action.payload;
			
			// i love that both !false and !undefined equal true
			// javascript makes coding so lazily fun..!
			state.selectedMatches[matchKey] = !state.selectedMatches[matchKey];
			if (!state.selectedMatches[matchKey]) delete state.selectedMatches[matchKey];
			
			// to get list of selected matches:
			// Object.keys(state.selectedMatches)
		}
	},
});

// dispatch(writeMatch(kpv))

export const { writeMatch, importMatches, deleteSingleMatch, deleteMatches, toggleSelectMatch } = matchSlice.actions;

// The function below is called a selector and allows us to select a value from
// the state. Selectors can also be defined inline where they're used instead of
// in the slice file. For example: `useSelector((state) => state.counter.value)`
export const selectMatches = state => state.matches.matches;
// what a funny name
export const selectSelectedMatches = state => state.matches.selectedMatches;

export default matchSlice.reducer;
