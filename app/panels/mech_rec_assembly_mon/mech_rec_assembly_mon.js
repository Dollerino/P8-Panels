/*
    Парус 8 - Панели мониторинга - ПУП - Мониторинг сборки изделий
    Панель мониторинга: Корневая панель мониторинга сборки изделий
*/

//---------------------
//Подключение библиотек
//---------------------

import React, { useState } from "react"; //Классы React
import PropTypes from "prop-types"; //Контроль свойств компонента
import {
    Drawer,
    Fab,
    Box,
    List,
    ListItemButton,
    ListItemText,
    Typography,
    TextField,
    FormGroup,
    FormControlLabel,
    Checkbox,
    Container,
    IconButton,
    Stack,
    Icon
} from "@mui/material"; //Интерфейсные элементы
import { ThemeProvider } from "@mui/material/styles"; //Подключение темы
import { PlanSpecsList } from "./components/plans_list"; //Список планов
import { PlanSpecDetail } from "./components/plan_detail"; //Детали плана
import { lightTheme, darkTheme } from "./styles/themes"; //Стиль темы
import { useMechRecAssemblyMon, useFilteredPlanCtlgs } from "./hooks"; //Вспомогательные хуки

//---------
//Константы
//---------

//Стили
const STYLES = {
    PLANS_FINDER: {
        marginTop: "10px",
        marginLeft: "10px",
        width: "93%",
        [`& .MuiFormLabel-root.Mui-focused`]: { color: "text.title.fontColor" },
        [`& .MuiInputBase-root`]: { color: "text.plans_finder.fontColor" },
        [`& .MuiInputBase-root.Mui-focused::after`]: { borderBottom: "2px solid black" }
    },
    PLANS_CHECKBOX_HAVEDOCS: {
        alignContent: "space-around",
        [`& .MuiCheckbox-root.Mui-checked`]: { color: "text.title.fontColor" }
    },
    PLANS_LIST_ITEM_ZERODOCS: { backgroundColor: "background.plans_zero_docs" },
    PLANS_LIST_ITEM_PRIMARY: { wordWrap: "break-word" },
    PLANS_LIST_ITEM_SECONDARY: { wordWrap: "break-word", fontSize: "0.6rem", textTransform: "uppercase" },
    PLANS_BUTTON: { position: "absolute" },
    PLANS_DRAWER: {
        width: "350px",
        display: "inline-block",
        flexShrink: 0,
        [`& .MuiDrawer-paper`]: {
            width: "350px",
            display: "inline-block",
            boxSizing: "border-box",
            backgroundColor: "background.plans_drawer_paper",
            color: "text.plans_finder.fontColor"
        }
    },
    PLANS_LIST_BOX: { paddingTop: "20px" },
    ROOT_BG: { backgroundColor: "background.main", minHeight: "calc(100vh - 64px)", overflow: "hidden" },
    THEME_CHANGER: { color: "text.title.fontColor" },
    MAIN_TITLE: { textAlign: "center", color: "text.title.fontColor", marginTop: "-24px" }
};

//------------------------------------
//Вспомогательные функции и компоненты
//------------------------------------

//Склонения для документов
const DECLINATIONS = ["план", "плана", "планов"];

//Форматирование для отображения количества документов
const formatCountDocs = nCountDocs => {
    //Получаем последнюю цифру в значении
    let num = (nCountDocs % 100) % 10;
    //Документов
    if (nCountDocs > 10 && nCountDocs < 20) return `${nCountDocs} ${DECLINATIONS[2]}`;
    //Документа
    if (num > 1 && num < 5) return `${nCountDocs} ${DECLINATIONS[1]}`;
    //Документ
    if (num == 1) return `${nCountDocs} ${DECLINATIONS[0]}`;
    //Документов
    return `${nCountDocs} ${DECLINATIONS[2]}`;
};

//Список каталогов планов
const PlanCtlgsList = ({ planCtlgs = [], selectedPlanCtlg, filter, setFilter, onClick } = {}) => {
    //Генерация содержимого
    return (
        <div>
            <TextField
                sx={STYLES.PLANS_FINDER}
                name="planFilter"
                label="Каталог"
                value={filter.ctlgName}
                variant="standard"
                fullWidth
                onChange={event => {
                    setFilter(pv => ({ ...pv, ctlgName: event.target.value }));
                }}
            ></TextField>
            <FormGroup sx={STYLES.PLANS_CHECKBOX_HAVEDOCS}>
                <FormControlLabel
                    control={<Checkbox checked={filter.haveDocs} onChange={event => setFilter(pv => ({ ...pv, haveDocs: event.target.checked }))} />}
                    label="Только с планами"
                    labelPlacement="end"
                />
            </FormGroup>
            <List>
                {planCtlgs.map(p => (
                    <ListItemButton
                        sx={p.NCOUNT_DOCS == 0 ? STYLES.PLANS_LIST_ITEM_ZERODOCS : null}
                        key={p.NRN}
                        selected={p.NRN === selectedPlanCtlg}
                        onClick={() => (onClick ? onClick({ NRN: p.NRN, SNAME: p.SNAME, NMIN_YEAR: p.NMIN_YEAR, NMAX_YEAR: p.NMAX_YEAR }) : null)}
                    >
                        <ListItemText
                            primary={<Typography sx={STYLES.PLANS_LIST_ITEM_PRIMARY}>{p.SNAME}</Typography>}
                            secondary={<Typography sx={{ ...STYLES.PLANS_LIST_ITEM_SECONDARY }}>{formatCountDocs(p.NCOUNT_DOCS)}</Typography>}
                        />
                    </ListItemButton>
                ))}
            </List>
        </div>
    );
};

//Контроль свойств - Список каталогов планов
PlanCtlgsList.propTypes = {
    planCtlgs: PropTypes.array,
    selectedPlanCtlg: PropTypes.number,
    onClick: PropTypes.func,
    filter: PropTypes.object,
    setFilter: PropTypes.func
};

//-----------
//Тело модуля
//-----------

//Корневая панель мониторинга сборки изделий
const MechRecAssemblyMon = () => {
    //Состояние - текущая тема
    const [theme, setTheme] = useState(lightTheme);
    //Собственное состояние
    const [state, setState, selectPlanCtlg, unselectPlanCtlg] = useMechRecAssemblyMon();

    //Состояние фильтра каталогов
    const [filter, setFilter] = useState({ ctlgName: "", haveDocs: false });

    //Состояние навигации по карточкам детализации
    const [planDetailNavigation, setPlanDetailNavigation] = useState({
        disableNavigatePrev: false,
        disableNavigateNext: false,
        currentPlanIndex: 0
    });

    //Массив отфильтрованных каталогов
    const filteredPlanCtgls = useFilteredPlanCtlgs(state.planCtlgs, filter);

    //Обработка нажатия на элемент в списке каталогов планов
    const handlePlanCtlgClick = planCtlg => {
        if (state.selectedPlanCtlg.NRN != planCtlg.NRN) selectPlanCtlg(planCtlg);
        else unselectPlanCtlg();
    };

    //Перемещение к нужному плану
    const navigateToPlan = planIndex => {
        if (planIndex < 0) planIndex = 0;
        if (planIndex > state.planSpecs.length - 1) planIndex = state.planSpecs.length - 1;
        setState(pv => ({
            ...pv,
            selectedPlanSpec: { ...state.planSpecs[planIndex] }
        }));
        setPlanDetailNavigation(pv => ({
            ...pv,
            disableNavigatePrev: planIndex == 0 ? true : false,
            disableNavigateNext: planIndex == state.planSpecs.length - 1 ? true : false,
            currentPlanIndex: planIndex
        }));
    };

    //Обработка нажатия на документ плана
    const handlePlanClick = (plan, planIndex) => navigateToPlan(planIndex);

    //Обработка нажатия на кнопку "Назад"
    const handlePlanDetailBackClick = () => {
        setState(pv => ({ ...pv, selectedPlanSpec: {} }));
    };

    //Обработка навигации из карточки с деталями плана
    const handlePlanDetailNavigateClick = direction => navigateToPlan(planDetailNavigation.currentPlanIndex + direction);

    //Обработка изменения темы
    const handleThemeChange = () => {
        setTheme(theme.palette.type === "light" ? darkTheme : lightTheme);
    };

    //Формирование текста заголовка
    const title = `${state.selectedPlanCtlg.SNAME} на ${state.selectedPlanCtlg.NMIN_YEAR} ${
        state.selectedPlanCtlg.NMIN_YEAR == state.selectedPlanCtlg.NMAX_YEAR ? "г." : `- ${state.selectedPlanCtlg.NMAX_YEAR} г.г.`
    } `;

    //Генерация содержимого
    return (
        <ThemeProvider theme={theme}>
            <Container maxWidth={false} disableGutters sx={STYLES.ROOT_BG}>
                <Box p={2}>
                    <Fab variant="extended" sx={STYLES.PLANS_BUTTON} onClick={() => setState(pv => ({ ...pv, showPlanList: !pv.showPlanList }))}>
                        Каталоги планов
                    </Fab>
                    <Drawer
                        anchor={"left"}
                        open={state.showPlanList}
                        onClose={() => setState(pv => ({ ...pv, showPlanList: false }))}
                        sx={STYLES.PLANS_DRAWER}
                    >
                        <PlanCtlgsList
                            planCtlgs={filteredPlanCtgls}
                            selectedPlanCtlg={state.selectedPlanCtlg.NRN}
                            filter={filter}
                            setFilter={setFilter}
                            onClick={handlePlanCtlgClick}
                        />
                    </Drawer>
                    <Stack display="flex" direction="row" justifyContent="flex-end" alignItems="center">
                        <IconButton onClick={() => handleThemeChange()}>
                            <Icon sx={STYLES.THEME_CHANGER}>{theme.palette.type === "light" ? "brightness_4" : "brightness_7"}</Icon>
                        </IconButton>
                    </Stack>
                    {state.init == true ? (
                        state.selectedPlanCtlg.NRN ? (
                            <>
                                <Typography variant="h3" sx={STYLES.MAIN_TITLE} pb={2}>
                                    {title}
                                </Typography>
                                {state.planSpecsLoaded == true ? (
                                    state.selectedPlanSpec.NRN ? (
                                        <PlanSpecDetail
                                            planSpec={state.selectedPlanSpec}
                                            disableNavigatePrev={planDetailNavigation.disableNavigatePrev}
                                            disableNavigateNext={planDetailNavigation.disableNavigateNext}
                                            onNavigate={handlePlanDetailNavigateClick}
                                            onBack={handlePlanDetailBackClick}
                                        />
                                    ) : (
                                        <Box sx={STYLES.PLANS_LIST_BOX}>
                                            <PlanSpecsList planSpecs={state.planSpecs} onItemClick={handlePlanClick} />
                                        </Box>
                                    )
                                ) : null}
                            </>
                        ) : (
                            <Typography variant="h4" sx={STYLES.MAIN_TITLE}>
                                Укажите каталог планов для отображения спецификаций
                            </Typography>
                        )
                    ) : null}
                </Box>
            </Container>
        </ThemeProvider>
    );
};

//----------------
//Интерфейс модуля
//----------------

export { MechRecAssemblyMon };
