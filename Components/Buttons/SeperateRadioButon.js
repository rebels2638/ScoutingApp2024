import {
	StyleSheet,
	Text,
	View,
	Pressable
} from "react-native";

import { setKeyPair, setDefault, selectID } from "../../Redux/Features/dataSlice.js";
import { useDispatch, useSelector } from "react-redux";

export default function SeperateRadioButton(props) {
	const dispatch = useDispatch();

	// set default value
	dispatch(setDefault([props.id, (props.data.findIndex(v => v===props.default)) || 0]));
	// get value from store
	const selectedIndex = useSelector(selectID(props.id));
    const buttonIndex = props.index || 0;
    const selectedColor = props.bgc || "orange";

	return (
		<Pressable onPress={() => {
			// if the press event exists, run it
			props.press && props.press();
			dispatch(setKeyPair([props.id, buttonIndex]));
		}}>
			<View style={{
				justifyContent: "center",
				borderRadius: 10,
				borderWidth: StyleSheet.hairlineWidth,
				margin: 10,
				height: 40,
				width: (props.width || 100),
				backgroundColor: (selectedIndex === buttonIndex ? selectedColor : "#FFF")
			}}>
				<Text style={{ textAlign: "center" }}>{props.children}</Text>
			</View>
		</Pressable>
	);
}