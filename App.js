/* eslint-disable react/display-name */
import * as React from "react";
import { useColorScheme } from "react-native";

import themes from "./Config/Themes";
import { NavigationContainer, DarkTheme, DefaultTheme } from "@react-navigation/native";
import { createBottomTabNavigator } from "@react-navigation/bottom-tabs";
import { StatusBar } from "expo-status-bar";
import AsyncStorage from "@react-native-async-storage/async-storage";
import { Octicons } from "react-native-vector-icons";

import store from "./Redux/Store.js";
import { Provider, useDispatch, useSelector } from "react-redux";
import { importMatches } from "./Redux/Features/matchSlice.js";

import Scout from "./Routes/Scout.js";
import PastMatches from "./Routes/PastMatches.js";
import About from "./Routes/About.js";
import ScoutingColors from "./Config/ScoutingColors";
import { selectID, setDefault, setKeyPair } from "./Redux/Features/dataSlice";
import { useEffect } from "react";

// create bottom tab navigation
const Tab = createBottomTabNavigator();

function MyTabs() {
	return (
		<Tab.Navigator initialRouteName="Scout" screenOptions={{tabBarActiveTintColor: ScoutingColors.ruby}}>
			<Tab.Screen name="Scout" component={Scout} options={{
				tabBarLabel: "Scout",
				tabBarIcon: ({ color, size }) => <Octicons name="checklist" color={color} size={size} />
			}}/>
			<Tab.Screen name="PastMatches" component={PastMatches} options={{
				tabBarLabel: "Past Matches",
				tabBarIcon: ({ color, size }) => <Octicons name="clock" color={color} size={size} />
			}}/>
			<Tab.Screen name="About" component={About} options={{
				tabBarLabel: "About",
				tabBarIcon: ({ color, size }) => <Octicons name="info" color={color} size={size} />
			}}/>
		</Tab.Navigator>
	);
}

// Async Storage Setter ;)
// The ASS handles stuff like setting matches to [] if empty, and syncing AsyncStorage and state.matches
function ASS() {
	const dispatch = useDispatch();

	(async () => {
		const matches = await AsyncStorage.getItem("matches");

		if (matches == null) {
			//  If not found, set empty match data in AsyncStorage.
			await AsyncStorage.setItem("matches", "[]");
		} else {
			// otherwise sync state.matches.matches and AsyncStorage
			// remove any null entries
			const parsedMatches = JSON.parse(matches);
			const filteredMatches = parsedMatches.filter(v => v instanceof Array);

			// dispatch filteredMatches to redux matches
			dispatch(importMatches(filteredMatches));

			// save filteredMatches to AsyncStorage
			if (parsedMatches !== filteredMatches) {
				await AsyncStorage.setItem("matches", JSON.stringify(filteredMatches));
			}
		}
	})();

	// mmmm, look at that empty component return, it just gives me chills O_o
	return <></>;
}

function ThemedApp() {
	const dispatch = useDispatch();
	const scheme = useColorScheme() || "light";
	const selectedThemeIndex = useSelector(selectID("ThemeSelector"));
	
	useEffect(() => {
		const setupThemes = async () => {
			const storedThemeIndex = await AsyncStorage.getItem("theme");
			console.log("natsumi", storedThemeIndex);

			if (storedThemeIndex == null) {
				// default to Auto
				await AsyncStorage.setItem("theme", "0");
				dispatch(setKeyPair(["ThemeSelector", 0]));
			} else {
				dispatch(setKeyPair(["ThemeSelector", Number(storedThemeIndex)]));
			}
		}

		setupThemes();
	}, []);

	// if index is 0, resort to system theme. otherwise, select out of themes[i-1]
	const selectedThemeName = selectedThemeIndex===0? scheme : Object.keys(themes)[selectedThemeIndex-1];
	
	return (
		<>
			{/* 
			<RadioButton id="ThemeSelector" data={["auto", ...Object.keys(themes)]} default={"auto"} bgc="orange" segmentedButton />
			*/}
			<NavigationContainer theme={themes[selectedThemeName]}>
				<MyTabs />
			</NavigationContainer>

			<StatusBar style={scheme} />
		</>
	);
}

export default function App() {
	// make store global bc I want to see the data pls
	window.natsumi = store;
	// themes
	window.themes = themes;

	// shut up console.warn
	// console.warn = () => {}

	return (
		<Provider store={store}>
			{/** ASS must be inside the Provider to dispatch importMatches(), so I made it into a component. */}
			<ASS />
			<ThemedApp />
		</Provider>
	);
}