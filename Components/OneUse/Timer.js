import React, { useState, useEffect } from "react";
import {
	View
} from "react-native";
import { Text } from "../../Components/Themed/Text";
import BoolButton from "../Buttons/BoolButton.js";

import { setKeyPair, setDefault, selectID, selectBlendedID, consumeBlend } from "../../Redux/Features/dataSlice.js";
import { useDispatch, useSelector } from "react-redux";
import Link from "../Utility/Link.js";

export default function Timer(props) {
	const dispatch = useDispatch();
	const [isEnabled, setEnabled] = useState(false);
	const [seconds, setSeconds] = useState(0);

	// set default values
	dispatch(setDefault([props.id, 0]));

	// https://github.com/rebels2638/ScoutingApp2022/issues/18
	const blendedTime = useSelector(selectBlendedID(props.id));

	if (blendedTime !== null) {
		setSeconds(blendedTime);
		dispatch(consumeBlend(props.id));
		// stop timer on match reset/load
		setEnabled(false);
		dispatch(setKeyPair(["TimerClicked", false]));
	}

	const resetTimer = () => {
		setSeconds(0);
		dispatch(setKeyPair([props.id, seconds]));
		setEnabled(false);
		dispatch(setKeyPair(["TimerClicked", false]));
	}

	// when toggling the timer, save the time to redux
	const toggleTimer = () => {
		setEnabled(v => !v);
		dispatch(setKeyPair([props.id, seconds]));
	}
	
	useEffect(() => {
		const timerInterval = setInterval(() => {
			if (isEnabled) setSeconds(oldSeconds => oldSeconds + 1);
		}, 1000);

		// callback when isEnabled ends
		return () => clearInterval(timerInterval);

		// run when the timer is started/stopped
	}, [isEnabled]);

	return (
		<View style={{ alignItems: "center", flex: 1 }}>
			<Text style={{ fontSize: 20, fontWeight: "bold" }}>{props.children || "Stopwatch"}</Text>

			<Text>{(`${(seconds - (seconds % 60)) / 60}:${((seconds % 60) + "").padStart(2, "0")}`)}</Text>
			
			<BoolButton id="TimerClicked" bgc="lime" width={160} press={toggleTimer}>
				<Text>{!isEnabled ? "Start" : "Stop"} Stopwatch</Text>
			</BoolButton>

			<Link color="red" onPress={resetTimer}>Reset Timer</Link>
		</View>
	);
}