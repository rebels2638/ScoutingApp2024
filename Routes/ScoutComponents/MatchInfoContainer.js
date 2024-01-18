import {
	StyleSheet,
	View,
	Image
} from "react-native";
import { Text } from "../../Components/Themed/Text";

import Incrementer from "../../Components/Utility/Incrementer.js";
import CustomTextBox from "../../Components/Utility/CustomTextBox.js";
import RadioButton from "../../Components/Buttons/RadioButton.js";
import { useSelector } from "react-redux";
import { selectID } from "../../Redux/Features/dataSlice.js";
import { useTheme } from "@react-navigation/native";

export default function MatchInfoContainer() {
	const { colors } = useTheme();

	return (
		<View style={{backgroundColor: colors.background, paddingHorizontal: 50, paddingVertical: 20}}>
			<Text style={{ textAlign: "center", fontSize: 35, fontWeight: "bold" }}>Match Info</Text>

			<View style={[styles.boundingBox, {borderColor: colors.border}]}>
				<View style={[styles.piecesContainer, {backgroundColor: colors.card}]}>
					<View style={styles.inputContainer}>
						<Text style={styles.bold}>Scouters: </Text>
						<View style={{ flex: 1, paddingLeft: 5 }}>
							<CustomTextBox id="Scouters" placeholder="Name and Name" width={350} height={40} />
						</View>
					</View>

					<View style={styles.inputContainer}>
						<Text style={styles.bold}>Match Type: </Text>
						<RadioButton
							id="MatchType"
							data={["Practice", "Qualification", "Playoff"]}
							bgc="orange"
							segmentedButton
							default="Practice"
						/>
					</View>
				</View>



				<View style={[styles.piecesContainer, {backgroundColor: colors.card}]}>
					<View style={styles.inputContainer}>
						<Text style={styles.bold}>Team Number: </Text>
						<View style={{ flex: 1, paddingLeft: 5 }}>
							<CustomTextBox id="TeamNumber" placeholder="2638" keyboardType="numeric" width={80} height={40} />
						</View>
					</View>

					<View style={styles.inputContainer}>
						<Text style={styles.bold}>Match Number: </Text>
						<Incrementer id="MatchNumber" />
					</View>

					<View style={styles.inputContainer}>
						<Text style={styles.bold}>Starting Position: </Text>
						<RadioButton id="StartingPosition" data={["Left", "Middle", "Right"]} bgc="orange" segmentedButton default="Left" />
					</View>
				</View>
			</View>
		</View>
	);
}

const styles = StyleSheet.create({
	bold: {
		fontSize: 17,
		fontWeight: "bold"
	},
	inputContainer: {
		flex: 1,
		flexDirection: "row",
		alignItems: "center",
		paddingVertical: 15
	},
	boundingBox: {
		flex: 1,
		flexDirection: "row",
		borderWidth: StyleSheet.hairlineWidth,
		borderRadius: 10,
		overflow: "hidden"
	},
	piecesContainer: {
		flex: 1,
		paddingHorizontal: 30,
		paddingVertical: 10,
	},
});