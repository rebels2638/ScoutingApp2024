import {
	StyleSheet,
	View,
	Text as RNText
} from "react-native";
import { Text } from "../../Components/Themed/Text";

import BoolButton from "../../Components/Buttons/BoolButton.js";
import NumButton from "../../Components/Buttons/NumButton.js";
import CustomTextBox from "../../Components/Utility/CustomTextBox.js";
import Grid from "../../Components/OneUse/Grid.js";

import { useSelector, useDispatch } from "react-redux";
import { selectID, setDefault } from "../../Redux/Features/dataSlice.js";
import RadioButton from "../../Components/Buttons/RadioButton.js";
import Spacer from "../../Components/Utility/Spacer.js";
import { useTheme } from "@react-navigation/native";
import Timer from "../../Components/OneUse/Timer.js";

export default function Autonomous() {
	const arenaID = "Team";
	const dispatch = useDispatch();

	// set default
	dispatch(setDefault([arenaID, 0]));
	// get value from store
	const { colors } = useTheme();

	return (
		<View style={[styles.container, {backgroundColor: colors.background}]}>
			<Text style={{ textAlign: "center", fontSize: 35, fontWeight: "bold" }}>Autonomous</Text>
			<View style={[styles.autonomousContainer, {borderColor: colors.border, backgroundColor: colors.card}]}>
				<BoolButton id="Taxi" bgc="lime" width={160}>Does Taxi</BoolButton>

				<Grid id="AutoGrid"/>

				<Spacer/>

				<NumButton id="AutoMissed" width={160}>Auto Missed</NumButton>
				
				<RadioButton id="AutoClimb" data={["None", "Docked", "Engaged", "Failed"]} bgc="orange" segmentedButton/>
				<Timer id="AutoTimeToEngaged">Time to Engaged</Timer>
				
				<Text style={{ textAlign: "center", fontSize: 20, fontWeight: "bold" }}>Comments</Text>
				<Text style={{ textAlign: "center", fontSize: 14, marginLeft: 20, marginRight: 20, marginTop: 10 }}>
					Add any comments that you feel are useful. Do they struggle with picking up balls or scoring?
					Does the robot cycle effectively? Anything else that shows evidence of good/poor performance.
				</Text>
				<View style={{ padding: 20 }}>
					<CustomTextBox
						multi={true}
						id="AutonomousComments"
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
	autonomousContainer: {
		alignItems: "center",
		borderRadius: 10,
		borderWidth: StyleSheet.hairlineWidth
	},
	container: {
		paddingHorizontal: 50,
		paddingVertical: 20
	},
	imageBackground: {
		flexDirection: "row",
		height: 500,
		marginTop: 20,
		width: 975
	}
});