import {
	StyleSheet,
	Text,
	View,
} from "react-native";

import { useDispatch, useSelector } from "react-redux";
import { setDefault, selectID } from "../../Redux/Features/dataSlice.js";
import Link from "../../Components/Utility/Link.js";
import ScoutingColors from "../../Config/ScoutingColors.js";

export default function Header() {
	const dispatch = useDispatch();
	const arenaID = "Team";

	// set default value
	dispatch(setDefault([arenaID, 0]));
	// since this isn't an input, no need to set default.
	// get value from store
	const selectedTeam = useSelector(selectID(arenaID));

	return (
		<View style={{
			backgroundColor: selectedTeam == 1 ? ScoutingColors.lightRed : ScoutingColors.lightBlue,
			flex: 1,
			borderBottomColor: ScoutingColors.doveGray,
			borderBottomWidth: StyleSheet.hairlineWidth
		}}>
			<Text style={styles.headerText}>2023 - Charged Up{"\n"}</Text>
			<View style={styles.linkContainer}>
				<Link>About</Link>
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