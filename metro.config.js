module.exports = {
	transformer: {
		minifierPath: "metro-minify-terser",
		minifierConfig: {
			ecma: 8,
			keep_classnames: true,
			keep_fnames: true,
			module: true,
			mangle: {
				module: true,
				keep_classnames: true,
				keep_fnames: true,
			},
		},
	},
};