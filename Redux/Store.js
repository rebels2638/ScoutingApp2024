import { configureStore } from "@reduxjs/toolkit";

import dataReducer from "./Features/dataSlice.js";
import matchReducer from "./Features/matchSlice.js";

// reducer list
const reducer = {
	data: dataReducer,
	matches: matchReducer
};

// initial state
const preloadedState = {};



// our SINGLE SOURCE OF TRUTH! BOW DOWN TO configureStore ALMIGHTY!!!!
export default configureStore({
	reducer,
	preloadedState
});
