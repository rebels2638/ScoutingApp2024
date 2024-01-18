import {
	StyleSheet,
	Text,
	View,
	Platform,
	Alert
} from "react-native";

import AsyncStorage from "@react-native-async-storage/async-storage";
import * as Sharing from "expo-sharing";
import Link from "../../Components/Utility/Link.js";

import kpvToCsv from "../../Config/kpvToCsv.js";

import { useDispatch, useSelector } from "react-redux";
import { setDefault, selectID } from "../../Redux/Features/dataSlice.js";

import { selectMatches, selectSelectedMatches } from "../../Redux/Features/matchSlice.js";

import { deleteMatches } from "../../Redux/Features/matchSlice.js";
import { FileSystem } from "react-native-unimodules";
import ScoutingColors from "../../Config/ScoutingColors.js";

export default function Header() {
	const dispatch = useDispatch();
	const arenaID = "Team";

	const matches = useSelector(selectMatches);
	const selectedMatches = useSelector(selectSelectedMatches);
	const selectedMatchKeysLength = Object.keys(selectedMatches).length;

	// set default value
	dispatch(setDefault([arenaID, 0]));
	// since this isn't an input, no need to set default.
	// get value from store
	const selectedTeam = useSelector(selectID(arenaID));

	const clickDeleteMatches = () => {
		const humanizedMatchText = selectedMatchKeysLength===0? 
						"all matches" :
						`${selectedMatchKeysLength} match${selectedMatchKeysLength===1? "" : "es"}`;

		const imLookingForwardToFriday = async () => {
			if (selectedMatchKeysLength === 0) {
				AsyncStorage.removeItem("matches");
			} else {
				const matchString = await AsyncStorage.getItem("matches");
				const filteredMatches = JSON.parse(matchString).filter(([matchKey]) => !Object.keys(selectedMatches).includes(matchKey))
				AsyncStorage.setItem("matches", JSON.stringify(filteredMatches));
			}
		}
		
		if (Platform.OS === "web") {
			if (confirm(`Are you ABSOLUTELY SURE you want to delete ${humanizedMatchText}?`)) {
				//AsyncStorage.removeItem("matches");
				imLookingForwardToFriday();

				dispatch(deleteMatches());
				alert(`Cleared ${humanizedMatchText}!`);
			}
		} else {
			Alert.alert(
				"Reset", `Are you ABSOLUTELY SURE you want to delete ${humanizedMatchText}? This action is not reversible.`,
				[
					{ text: "Reset", onPress: () => {
						//AsyncStorage.removeItem("matches");
						imLookingForwardToFriday();
						
						dispatch(deleteMatches());
						alert(`Cleared ${humanizedMatchText}!`);
					}},
					{ text: "Cancel", style: "cancel" }
				]
			);
		}
	};

	const clickExportAllMatches = () => {
		// write new csv file
		const filteredMatches = selectedMatchKeysLength !== 0?
									matches.filter(([matchKey]) => Object.keys(selectedMatches).includes(matchKey)) :
									matches;
		const output = kpvToCsv(filteredMatches);

		Platform.OS == "web"
			? webExport(output, `scouting-${Date.now()}.csv`)
			: mobileExport(output);
	};

	function webExport(content, fileName) {
		let a = document.createElement("a"); 
		let mimeType = "text/csv;encoding:utf-8";

		// Thanks, stackoverflow
		if (URL && "download" in a) {
			a.href = URL.createObjectURL(new Blob([content], {
				type: mimeType
			}));
			a.setAttribute("download", fileName);
			document.body.appendChild(a);
			a.click();
			document.body.removeChild(a);
		} else {
			location.href = "data:application/octet-stream," + encodeURIComponent(content);
		}
	}

	async function mobileExport(output) {
		const path = "./data.csv";

		FileSystem.writeAsStringAsync(FileSystem.documentDirectory + path, output, { encoding: FileSystem.EncodingType.UTF8 });
		// share the new csv file we just made
		try {
			await Sharing.shareAsync(FileSystem.documentDirectory + path);
		} catch (e) {
			alert(e.message);
		}
	}


	return (
		<View style={{
			backgroundColor: selectedTeam == 1 ? ScoutingColors.lightRed : ScoutingColors.lightBlue,
			flex: 1,
			borderBottomColor: ScoutingColors.doveGray,
			borderBottomWidth: StyleSheet.hairlineWidth
		}}>
			<Text style={styles.headerText}>2023 - Charged Up{"\n"}</Text>
			<View style={styles.linkContainer}>
				<Link color="red" onPress={clickDeleteMatches}>
					{selectedMatchKeysLength===0? 
						"Delete All Matches" :
						`Delete ${selectedMatchKeysLength} Match${selectedMatchKeysLength===1? "" : "es"}`
					}
				</Link>

				<Link color="blue" onPress={clickExportAllMatches}>
					{selectedMatchKeysLength===0? 
						"Export All Matches" :
						`Export ${selectedMatchKeysLength} Match${selectedMatchKeysLength===1? "" : "es"}`
					}
				</Link>
			</View>
		</View>
	);
}

const styles = StyleSheet.create({
	headerText: {
		flex: 1,
		fontSize: 20,
		paddingTop: 10,
		textAlign: "center"
	},
	linkContainer: {
		flex: 1,
		flexDirection: "row",
		alignItems: "center",
		justifyContent: "space-between",
		paddingHorizontal: 30,
		paddingBottom: 15,
		paddingTop: 10
	}
});