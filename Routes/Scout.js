import {
	View,
	ScrollView,
	Dimensions
} from "react-native";

import Header from "./ScoutComponents/Header.js";
import MatchInfoContainer from "./ScoutComponents/MatchInfoContainer.js";
import Autonomous from "./ScoutComponents/Autonomous.js";
import TeleOp from "./ScoutComponents/TeleOp.js";
import Endgame from "./ScoutComponents/EndGame.js";
import Other from "./ScoutComponents/Other.js";

/** Test Components */

export default function Scout() {
	return (
		<View style={{ flex: 1 }}>
			<View style={{ height: Dimensions.get('window').height*0.123 }}>
				<Header />
			</View>

			<View style={{ flex: 1 }}>
				<ScrollView>
					<MatchInfoContainer />
					<Autonomous />
					<TeleOp />
					<Endgame />
					<Other />
				</ScrollView>
			</View>
		</View>
	);
}