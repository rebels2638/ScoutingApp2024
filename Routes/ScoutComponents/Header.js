import {
	StyleSheet,
	Text,
	View,
	Alert,
	Platform
} from "react-native";

import AsyncStorage from "@react-native-async-storage/async-storage";
import * as Sharing from "expo-sharing";
import * as FileSystem from "expo-file-system";

import RadioButton from "../../Components/Buttons/RadioButton.js";
import Link from "../../Components/Utility/Link.js";

import { useDispatch, useSelector } from "react-redux";
import { setDefault, freshStart, selectData, selectID } from "../../Redux/Features/dataSlice.js";
import { writeMatch } from "../../Redux/Features/matchSlice.js";
import kpvToCsv from "../../Config/kpvToCsv.js";

import ScoutingColors from "../../Config/ScoutingColors";

export default function Header() {
	const dispatch = useDispatch();
	const arenaID = "Team";

	// set default value
	dispatch(setDefault([arenaID, 0]));
	// since this isn't an input, no need to set default.
	// get value from store
	const kpv = useSelector(selectData);
	const selectedTeam = useSelector(selectID(arenaID));

	function reset() {
		if (Platform.OS === "web") {
			if (confirm("Everyone needs a fresh start. Why not now?")) dispatch(freshStart());
		} else {
			Alert.alert(
				"Reset", "Are you sure you want to reset the Scoutsheet?",
				[
					{ text: "Reset", onPress: () => dispatch(freshStart()) },
					{ text: "Cancel", style: "cancel" }
				]
			);
		}
	}

	async function save(successCallback=_=>{}) {
		// fun fact, kpv is short for KeyPairValue, because it's filled with [key, value]
		// matchKey is a unique identifier for a match. Right now I could have Team
		const matchKey = ["Team", "TeamNumber", "MatchNumber", "MatchType", "Scouters"]
			.map(k => [k, kpv[k]]); // "Team" --> ["Team", value]

		// if a single one of them is ""...
		if (matchKey.some(v => v[1] === "")) {
			// find em
			// ["Team", value] --> "Team"
			const blank = matchKey
				.filter(v => v[1] === "")
				.map(v => v[0]);

			// formatting
			// prepend "and " to last item
			// 1, 2, 3, 4, and 5 are blank
			if (blank.length > 1) blank[blank.length - 1] = "and " + blank[blank.length - 1];

			alert(`${blank.join(", ")} is blank!`);
			// stop save()'ing
			return;
		}

		const final = [matchKey.join(""), kpv];

		// get matches OR default []
		const matches = JSON.parse(await AsyncStorage.getItem("matches")) || [];
		// make sure the item actually exists, then check against matchKey
		const mki = matches.findIndex(v => v && (v[0] === final[0]));

		const saveMatch = () => {
			// put all our matches back in a place where it'll be safe and sound <3
			AsyncStorage.setItem("matches", JSON.stringify(matches));
			// now update matches in redux
			dispatch(writeMatch(final));

			// now we're finished
			successCallback(final);
		};

		// add our lovely changes
		if (mki === -1) {
			// if the match key is not found
			// push
			matches.push(final);
			saveMatch();
		} else {
			// if the match key IS found
			// overwrite
			if (Platform.OS === "web") {
				if (confirm("A match already exists with this match key. Are you sure you want to overwrite it?")) {
					matches[mki] = final;
					saveMatch();
				}
			} else {
				Alert.alert(
					"Overwrite", "A match already exists with this match key. Are you sure you want to overwrite it?",
					[
						{ text: "Overwrite", onPress: () => {
							matches[mki] = final;
							saveMatch();
						}},
						{ text: "Cancel", style: "cancel" }
					]
				);
			}
			
		}
	}

	function saveAndExport() {
		save(final => {
			if (final === undefined) return;
			const output = kpvToCsv([final]);

			Platform.OS == "web"
				? webExport(output, "data.csv")
				: mobileExport(output);
		});
	}

	function webExport(content, fileName) {
		let a = document.createElement("a");
		let mimeType = "text/csv;encoding:utf-8";

		// Thanks, stackoverflow
		if (URL && "download" in a) {
			a.href = URL.createObjectURL(new Blob([content], { type: mimeType }));
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
				<Link color={ScoutingColors.red} onPress={() => reset()}>Reset</Link>

				<Link></Link>

				<RadioButton
					id="Team"
					data={["Blue Alliance", "Red Alliance"]}
					bgc="orange"
					segmentedButton
					options={{
						flexDirection: "row",
					}}
				/>
					
				<Link color={ScoutingColors.blue} onPress={() => save(() => alert("Saved Match #" + kpv["MatchNumber"]))}>Save</Link>

				<Link color={ScoutingColors.blue} onPress={() => saveAndExport()}>Save and Export</Link>
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