import {
	StyleSheet,
	View
} from "react-native";
import { Text } from "../../Components/Themed/Text";

import BoolButton from "../../Components/Buttons/BoolButton";
import NumButton from "../../Components/Buttons/NumButton";
import { useTheme } from "@react-navigation/native";
import RadioButton from "../../Components/Buttons/RadioButton";
import Grid from "../../Components/OneUse/Grid";

export default function Other() {
	const { colors } = useTheme();

	return (
		<View style={[styles.container, {backgroundColor: colors.background}]}>
			<Text style={{ textAlign: "center", fontSize: 35, fontWeight: "bold" }}>Other</Text>
			<View style={[styles.otherContainer, {backgroundColor: colors.card, borderColor: colors.border}]}>
				<View style={{display: "flex"}}>
					<View style={{flexDirection: "row", alignItems: "center"}}>
						<BoolButton id="Breakdown" bgc="orange" width={160}>Breakdown</BoolButton>
						<BoolButton id="GroundPickup" bgc="orange" width={160}>Ground Pickup</BoolButton>
						<BoolButton id="ChutePickup" bgc="orange" width={160}>Chute Pickup</BoolButton>
						<BoolButton id="PlatformPickup" bgc="orange" width={160}>Platform Pickup</BoolButton>
						<RadioButton id="GamePiecePickup" data={["Cone", "Cube", "Both"]} bgc="orange" segmentedButton/>
					</View>

					<View>
						<Text style={{ textAlign: "center", fontSize: 20, fontWeight: "bold" }}>Alliance Game Pieces</Text>
						<Grid id="AllianceScoredPosition"/>
					</View>
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
	otherContainer: {
		flex: 1,
		flexDirection: "row",
		alignItems: "center",
		justifyContent: "space-around",
		borderWidth: StyleSheet.hairlineWidth,
		borderRadius: 10,
		paddingVertical: 20,
		paddingBottom: 20
	}
});
