import {
	View
} from "react-native";

export default function Spacer(props) {
	return (
		<View style={{ margin: props.v || 10 }}></View>
	);
}
