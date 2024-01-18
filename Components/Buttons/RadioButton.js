import {
	StyleSheet,
	Text,
	View,
	Pressable
} from "react-native";

import { setKeyPair, setDefault, selectID } from "../../Redux/Features/dataSlice.js";
import { useDispatch, useSelector } from "react-redux";

import { useTheme } from "@react-navigation/native";

export default function RadioButton(props) {
	const dispatch = useDispatch();
	const { colors } = useTheme();

	const BORDER_RADIUS = 10;

	// set default value
	if (props.default) dispatch(setDefault([props.id, (props.data.findIndex(v => v===(props.default)))]));
	else dispatch(setDefault([props.id, 0]));
	
	// get value from store
	const selectedIndex = useSelector(selectID(props.id));
	const selectedColor = props.bgc || "orange";

	return (
		<View style={{ flexDirection: "row", ...props.options }}>
			{
				props.data.map((v, i) =>
					<Pressable
						key={v}
						onPress={() => {
							dispatch(setKeyPair([props.id, i]));
							if (props.onPress) props.onPress(i);
						}}
					>
						<View style={{
							justifyContent: "center",
							borderWidth: StyleSheet.hairlineWidth,
							borderColor: colors.border,
							margin: props.margin ? props.margin : 0,
							width: (props.width ? props.width : 100),
							height: 40,
							backgroundColor: (selectedIndex === i ? selectedColor : colors.background),

							/** The ternary operator pretends to be your friend, until you realize a few months later,
							 *  when you don't understand any of your code, that it was actually the spawn of Satan
							 **/
							borderTopLeftRadius: props.segmentedButton ? (i == 0 ? BORDER_RADIUS : 0) : BORDER_RADIUS,
							borderBottomLeftRadius: props.segmentedButton ? (i == 0 ? BORDER_RADIUS : 0) : BORDER_RADIUS,

							borderTopRightRadius: props.segmentedButton ? (i == props.data.length - 1 ? BORDER_RADIUS : 0) : BORDER_RADIUS,
							borderBottomRightRadius: props.segmentedButton ? (i == props.data.length - 1 ? BORDER_RADIUS : 0) : BORDER_RADIUS
						}}>
							<Text style={{ textAlign: "center", color: (selectedIndex === i? "#000" : colors.text) }}>{v}</Text>
						</View>
					</Pressable>
				)
			}
		</View>
	);
}