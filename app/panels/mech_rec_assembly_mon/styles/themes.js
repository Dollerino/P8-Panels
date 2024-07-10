import { createTheme } from "@mui/material/styles"; //Интерфейсные элементы

//---------
//Константы
//---------

//Насыщенность шрифта
const FONT_WEIGHT_NORMAL = 400;
const FONT_WEIGHT_BOLD = 700;

//Выравнивание текста
const TEXT_ALIGN_CENTER = "center";

//Стиль для детализации прогресса и сообщения таблицы детализации
const smallSizedText = {
    fontSize: "12px",
    fontWeight: FONT_WEIGHT_NORMAL,
    whiteSpace: "pre-line",
    textAlign: TEXT_ALIGN_CENTER,
    wordWrap: "break-word",
    letterSpacing: "0.00938em",
    lineHeight: "1.5"
};

//Стили кастомных шрифтов
const customTypography = {
    h1: {
        fontSize: "40px",
        fontWeight: FONT_WEIGHT_NORMAL,
        textAlign: TEXT_ALIGN_CENTER
    },
    h2: {
        fontSize: "40px",
        fontWeight: FONT_WEIGHT_BOLD,
        textAlign: TEXT_ALIGN_CENTER
    },
    h3: {
        fontSize: "30px",
        fontWeight: FONT_WEIGHT_BOLD,
        textAlign: TEXT_ALIGN_CENTER
    },
    h4: {
        fontSize: "16px",
        fontWeight: FONT_WEIGHT_NORMAL,
        textAlign: TEXT_ALIGN_CENTER
    },
    subtitle1: {
        fontSize: "30px",
        fontWeight: FONT_WEIGHT_NORMAL,
        textAlign: TEXT_ALIGN_CENTER
    },
    subtitle2: {
        fontSize: "20px",
        fontWeight: FONT_WEIGHT_BOLD,
        textAlign: TEXT_ALIGN_CENTER
    },
    body3: {
        fontSize: "9px",
        whiteSpace: "pre-line",
        textAlign: TEXT_ALIGN_CENTER
    },
    PlanSpecInfo: {
        fontSize: "14px",
        fontWeight: FONT_WEIGHT_NORMAL,
        textAlign: TEXT_ALIGN_CENTER,
        wordWrap: "break-word",
        letterSpacing: "0.00938em",
        lineHeight: "1.5"
    },
    PlanSpecProgressDetail: {
        ...smallSizedText
    },
    ProductDetailMessage: {
        ...smallSizedText
    }
};

//---------
//Описание темы
//---------

const lightTheme = createTheme({
    palette: {
        type: "light",
        background: {
            main: "#fff",
            secondary: "#fff",
            progress: "#fff",
            detail_table: "#fff",
            detail_info: "#fff",
            product_selector: "#fff",
            plans_zero_docs: "#ebecec",
            plans_drawer_paper: "#fff"
        },
        text: {
            title: { fontColor: "rgba(0, 0, 0, 0.65)" },
            detail_table: { fontColor: "rgba(0, 0, 0, 0.87)" },
            secondary: { fontColor: "rgba(0, 0, 0, 0.298)" },
            plans_finder: { fontColor: "black" },
            more_button: { fontColor: "#1976d2" }
        }
    },
    typography: { ...customTypography }
});

const darkTheme = createTheme({
    palette: {
        type: "dark",
        background: {
            main: "#161616",
            secondary: "#d2d2d2",
            progress: "#e8e8e8",
            detail_table: "#3f3f3f",
            detail_info: "#d0d0d0",
            product_selector: "#eee",
            plans_zero_docs: "#323232",
            plans_drawer_paper: "#3f3f3f"
        },
        text: {
            title: { fontColor: "#fff" },
            detail_table: { fontColor: "#fff" },
            secondary: { fontColor: "rgba(0, 0, 0, 0.298)" },
            plans_finder: { fontColor: "#fff" },
            more_button: { fontColor: "#fff" }
        }
    },
    typography: { ...customTypography }
});

export { lightTheme, darkTheme };
