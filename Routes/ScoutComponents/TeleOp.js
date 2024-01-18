import {
	StyleSheet,
	View
} from "react-native";
import { Text } from "../../Components/Themed/Text";

import BoolButton from "../../Components/Buttons/BoolButton.js";
import NumButton from "../../Components/Buttons/NumButton.js";
import CustomTextBox from "../../Components/Utility/CustomTextBox.js";
import Grid from "../../Components/OneUse/Grid.js";

import { useDispatch } from "react-redux";
import { setDefault } from "../../Redux/Features/dataSlice.js";
import { useTheme } from "@react-navigation/native";

export default function TeleOp() {
	const dispatch = useDispatch();
	const { colors } = useTheme();
	const arenaID = "Team";

	// set default value
	dispatch(setDefault([arenaID, 0]));
	return (
		<View style={[styles.container, {backgroundColor: colors.background}]}>
			<Text style={{ textAlign: "center", fontSize: 35, fontWeight: "bold" }}>Tele-Op</Text>
			<View style={[styles.teleOpContainer, {borderColor: colors.border, backgroundColor: colors.card}]}>
				<Grid id="TeleopGrid"/>

				<NumButton id="TeleOpMissed" width={160}>TeleOp Missed</NumButton>
				<BoolButton id="PlaysDefense" bgc="lime" width={160}> Plays Defense</BoolButton>
				<BoolButton id="WasDefended" bgc="lime" width={160}> Was Defended</BoolButton>
				

				<Text style={{ textAlign: "center", fontSize: 20, fontWeight: "bold" }}>Comments</Text>
				<Text style={{ textAlign: "center", fontSize: 14, marginLeft: 20, marginRight: 20, marginTop: 10 }}>
					Add any comments that you feel are useful. Does the robot get any penalties? Does the robot cycle
					efficiently? Do they struggle with picking up balls or shooting? Do they usually shoot high or low?
					Anything else that shows evidence of good/poor performance.
				</Text>
				<View style={{ paddingLeft: 20, paddingRight: 20, paddingTop: 20, paddingBottom: 20 }}>
					<CustomTextBox
						multi={true}
						id="TeleopComments"
						width={900}
						height={250}
						placeholder="Type your comments here..."
						borderRadius={10}
					/>
				</View>
			</View>
		</View>
	);
}

const styles = StyleSheet.create({
	container: {
		paddingHorizontal: 50,
		paddingVertical: 20
	},
	teleOpContainer: {
		alignItems: "center",
		borderRadius: 10,
		borderWidth: StyleSheet.hairlineWidth
	}
});
