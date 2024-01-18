import {
	StyleSheet,
	View,
	Text as RNText,
	Pressable,
	ImageBackground
} from "react-native";
import { Text } from "../../Components/Themed/Text";

import { setKeyPair, setDefault, selectID } from "../../Redux/Features/dataSlice.js";
import { useDispatch, useSelector } from "react-redux";
import { useTheme } from "@react-navigation/native";

export default function ClimbPosition(props) {
	const dispatch = useDispatch();
	const { colors } = useTheme();

	dispatch(setDefault([props.id, 0]));
	const selectedIndex = useSelector(selectID(props.id));

	// all possible options.
	// [name, [x, y]]
	const data = [
		["None",      [0.1, 0.8]],
		["Low",       [0.3, 0.63]],
		["Medium",    [0.4, 0.42]],
		["High",      [0.47, 0.25]],
		["Traversal", [0.55, 0.1]]
	];

	const width = 800;
	const height = 400;

	return (
		<View style={{ alignItems: "center" }}>
			<Text style={{ fontWeight: "bold", fontSize: 20 }}>Climb Position</Text>

			<ImageBackground 
				source={require("../../Assets/2022/ClimbPosition2022.png")}
				style={{ width: width, height: height }}
				imageStyle={{ borderRadius: 10 }}
			>
				{
					data.map((v, i) => {
						const [value, position] = v;
						const [x, y] = position;

						return (
							<Pressable onPress={() => {dispatch(setKeyPair([props.id, i]))}} key={v}>
								<View style={[
									styles.button,
									{ position: "absolute", left: width*x, top: height*y, key: value,
										borderRadius: 10,
										borderColor: colors.border,
										backgroundColor: (selectedIndex===i? props.bgc : colors.background)}
								]}>
									<RNText style={{ textAlign: "center", color: (selectedIndex===i? "#000" : colors.text) }}>{value}</RNText>
								</View>
							</Pressable>
						);
					})
				}
			</ImageBackground>
		</View>
	);
}

const styles = StyleSheet.create({
	button: {
		justifyContent: "center",
		borderRadius: 10,
		borderWidth: StyleSheet.hairlineWidth,
		width: 100,
		height: 40,
	}
});