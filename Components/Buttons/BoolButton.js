import {
	StyleSheet,
	Text,
	View,
	Pressable
} from "react-native";
import { useTheme } from '@react-navigation/native';

import { setKeyPair, setDefault, selectID } from "../../Redux/Features/dataSlice.js";
import { useDispatch, useSelector } from "react-redux";

export default function BoolButton(props) {
	const dispatch = useDispatch();
	const { colors } = useTheme();

	// set default value
	dispatch(setDefault([props.id, props.default || false]));
	// get value from store
	const value = useSelector(selectID(props.id));

	return (
		<Pressable onPress={() => {
			// if the press event exists, run it
			props.press && props.press();
			dispatch(setKeyPair([props.id, !value]));
		}} style={{
			justifyContent: "center",
			borderRadius: 10,
			borderWidth: StyleSheet.hairlineWidth,
			margin: props.margin ?? 10,
			height: 40,
			width: (props.width || 100),
			backgroundColor: (value? props.bgc : colors.background),
			borderColor: colors.border
		}}>
			<Text style={{textAlign: "center", color: (value? "#000" : colors.text)}}>{props.children}</Text>
		</Pressable>
	);
}