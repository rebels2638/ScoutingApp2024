import { DefaultTheme, DarkTheme } from '@react-navigation/native';

const createTheme = (theme, colors) => ({
    dark: theme.dark,
    colors: {...theme.colors, blue: "#3BC4F9", red: "#D70A0A", ...colors}
});


// https://reactnavigation.org/docs/themes/
// you can build off of existing themes, and just add whatever changes you want afterwards
export default {
    light: createTheme(DefaultTheme, {border: "#000"}),
    dark: createTheme(DarkTheme, {card: "#252525", border: "#333"}),
    green: createTheme(DefaultTheme, {primary: "#6AA84F", card: "#5E9C43", background: "#84C966", border: "#000"})
}

// auto, light, dark, green...?