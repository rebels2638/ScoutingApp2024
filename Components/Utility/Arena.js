import {
	View,
	ImageBackground
} from "react-native";

import { selectID, setDefault } from "../../Redux/Features/dataSlice.js";
import { useSelector, useDispatch } from "react-redux";
import { useTheme } from "@react-navigation/native";

export default function Arena(props) {
	const dispatch = useDispatch();
	const arenaID = "Team";
	const { colors } = useTheme();

	// set default value
	dispatch(setDefault([arenaID, 0]));
	// since this isn't an input, no need to set default.
	// get value from store
	const selectedTeam = useSelector(selectID(arenaID));

	return (
		<View>
			<ImageBackground
				source={require("../../Assets/2022/2022Field.png")}
				style={{
					flexDirection: selectedTeam == 0 ? "row" : "row-reverse",
					height: 453,
					marginTop: 20,
					width: 900
				}}
				imageStyle={{ borderRadius: 10, borderColor: colors.border }}
			>
				{props.children}
			</ImageBackground>
		</View>
	);
}
