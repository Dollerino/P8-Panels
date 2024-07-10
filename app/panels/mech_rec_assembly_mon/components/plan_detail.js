/*
    Парус 8 - Панели мониторинга - ПУП - Мониторинг сборки изделий
    Панель мониторинга: Детализация по объекту
*/

//---------------------
//Подключение библиотек
//---------------------

import React, { useEffect, useState } from "react"; //Классы React
import PropTypes from "prop-types"; //Контроль свойств компонента
import { Box, Grid, Container, Button, Typography, Icon, Stack, IconButton, CircularProgress } from "@mui/material"; //Интерфейсные элементы
import { P8PDataGrid, P8P_DATA_GRID_SIZE } from "../../../components/p8p_data_grid"; //Таблица данных
import { P8PSVG } from "../../../components/p8p_svg"; //Интерактивные изображения
import { P8P_DATA_GRID_CONFIG_PROPS } from "../../../config_wrapper"; //Подключение компонентов к настройкам приложения
import { useCostProductComposition, useProductDetailsTable } from "../hooks"; //Вспомогательные хуки
import { ProgressBox } from "./progress_box"; //Информация по прогрессу объекта

//---------
//Константы
//---------

//Стили
const STYLES = {
    BOX_INFO_MAIN: {
        border: "1px solid",
        borderRadius: "25px",
        height: "35vh",
        backgroundColor: "background.detail_table"
    },
    BOX_INFO_SUB: isMessage => ({
        overflow: "hidden",
        textAlign: "center",
        width: "100%",
        height: "100%",
        display: "flex",
        flexDirection: "column",
        justifyContent: isMessage ? "center" : "flex-start",
        paddingLeft: "5px",
        paddingRight: "5px",
        ...(isMessage ? { padding: "5px" } : { paddingTop: "10px" })
    }),
    DETAIL_INFO: {
        display: "flex",
        justifyContent: "space-around",
        alignItems: "center",
        border: "1px solid",
        borderRadius: "25px",
        height: "17vh",
        backgroundColor: "background.detail_info"
    },
    PRODUCT_SELECTOR_CONTAINER: {
        display: "flex",
        justifyContent: "center",
        alignItems: "center",
        flexDirection: "column",
        border: "1px solid",
        borderRadius: "25px",
        height: "53vh",
        marginTop: "16px",
        backgroundColor: "background.product_selector"
    },
    PRODUCT_SELECTOR_MODEL: { width: "70%" },
    PLAN_INFO_MAIN: {
        display: "flex",
        flexDirection: "column",
        gap: "16px"
    },
    PLAN_INFO_SUB: {
        display: "flex",
        justifyContent: "space-between",
        width: "280px",
        borderBottom: "1px solid"
    },
    TABLE_DETAILS: { backgroundColor: "background.detail_table", height: "240px" },
    TABLE_DETAILS_HEADER_CELL: maxWidth => ({
        backgroundColor: "background.detail_table",
        color: "text.detail_table.fontColor",
        padding: "2px 2px",
        fontSize: "11px",
        textAlign: "center",
        lineHeight: "1rem",
        ...(maxWidth ? { maxWidth } : {})
    }),
    TABLE_DETAILS_DATA_CELL: textAlign => ({
        backgroundColor: "background.detail_table",
        color: "text.detail_table.fontColor",
        padding: "2px 2px",
        fontSize: "11px",
        ...(textAlign ? { textAlign } : {})
    }),
    TABLE_DETAILS_MORE_BUTTON: { borderRadius: "25px", height: "20px", color: "text.more_button.fontColor" },
    TABLE_DETAILS_TEXT: { color: "text.detail_table.fontColor" },
    CARD_DETAILS_CONTAINER: { minWidth: "1200px", maxWidth: "1400px" },
    CARD_DETAILS_NAVIGATION_STACK: { width: "100%" },
    NAVIGATE_BUTTONS: { color: "text.title.fontColor" }
};

//------------------------------------
//Вспомогательные функции и компоненты
//------------------------------------

//Информация о выпуске плана
const PlanSpecInfo = ({ planSpec }) => {
    return (
        <>
            <Box sx={STYLES.PLAN_INFO_MAIN}>
                <Box sx={STYLES.PLAN_INFO_SUB}>
                    <Typography variant="PlanSpecInfo" mt={1}>
                        Номер борта:
                    </Typography>
                    <Typography variant="subtitle2">{planSpec.SNUMB}</Typography>
                </Box>
                <Box sx={STYLES.PLAN_INFO_SUB}>
                    <Typography variant="PlanSpecInfo" mt={1}>
                        Год выпуска:
                    </Typography>
                    <Typography variant="subtitle2">{planSpec.NYEAR}</Typography>
                </Box>
            </Box>
            <ProgressBox
                progress={planSpec.NPROGRESS}
                detail={planSpec.SDETAIL}
                width={"110px"}
                height={"110px"}
                progressVariant={"subtitle2"}
                detailVariant={"body3"}
            />
        </>
    );
};

//Контроль свойств - Информация о спецификации плана
PlanSpecInfo.propTypes = {
    planSpec: PropTypes.object
};

//Модель выпуска плана
const PlanSpecProductCompositionModel = ({ model, products, onProductSelect }) => {
    //При выборе детали на модели
    const handleProductClick = ({ item }) => {
        const product = products.find(p => p.SMODEL_ID == item.id);
        if (product && onProductSelect) onProductSelect(product);
    };

    //Генерация содержимого
    return (
        <>
            <Box sx={STYLES.PRODUCT_SELECTOR_MODEL}>
                {model ? (
                    <P8PSVG
                        data={atob(model)}
                        items={products.map(p => ({ id: p.SMODEL_ID, backgroundColor: p.SMODEL_BG_COLOR || "red", desc: p.SNAME, title: p.SNAME }))}
                        fillOpacity={"0.3"}
                        onItemClick={handleProductClick}
                    />
                ) : (
                    <Typography variant="subtitle2">Модель изделия не загружена</Typography>
                )}
            </Box>
        </>
    );
};

//Контроль свойств - Модель выпуска плана
PlanSpecProductCompositionModel.propTypes = {
    model: PropTypes.any,
    products: PropTypes.array,
    onProductSelect: PropTypes.func
};

//Генерация представления ячейки заголовка
const headCellRender = ({ columnDef }) => ({
    stackProps: { justifyContent: "center" },
    cellStyle: STYLES.TABLE_DETAILS_HEADER_CELL(
        ["NREMN_LABOUR", "NAPPLICABILITY"].includes(columnDef.name) ? "90px" : ["NDEFICIT"].includes(columnDef.name) ? "55px" : null
    )
});

//Генерация заливки строки исходя от значений
const dataCellRender = ({ row, columnDef }) => ({
    cellStyle: STYLES.TABLE_DETAILS_DATA_CELL(["SOPERATION", "SNOMEN"].includes(columnDef.name) ? null : "center"),
    data: row[columnDef]
});

//Таблица детализации изделия
const ProductDetailsTable = ({ planSpec, product, stored, noProductMessage, noPlanSpecMessage, noDataFoundMessage, title }) => {
    //Собственное состояние
    const [state, setState] = useState({ planSpec: null, product: null, orders: null, pageNumber: 1 });

    //Собственное состояние - данные таблицы
    const { data, isLoading } = useProductDetailsTable(state.planSpec, state.product, state.orders, state.pageNumber, stored);

    //При изменении состояния сортировки
    const handleOrderChanged = ({ orders }) => setState(pv => ({ ...pv, orders: [...orders], pageNumber: 1 }));

    //При изменении количества отображаемых страниц
    const handlePagesCountChanged = () => setState(pv => ({ ...pv, pageNumber: pv.pageNumber + 1 }));

    //При изменении изделия
    useEffect(() => {
        setState(pv => ({ ...pv, planSpec, product, orders: null, pageNumber: 1 }));
    }, [product, planSpec]);

    //Генерация содержимого
    return (
        <Box sx={STYLES.BOX_INFO_SUB(!product || data.rows.length === 0)}>
            {!product ? (
                <Typography variant="ProductDetailMessage" sx={STYLES.TABLE_DETAILS_TEXT}>
                    {noProductMessage}
                </Typography>
            ) : !planSpec ? (
                <Typography variant="ProductDetailMessage" sx={STYLES.TABLE_DETAILS_TEXT}>
                    {noPlanSpecMessage}
                </Typography>
            ) : (
                <>
                    <Stack direction="row" spacing={2} justifyContent="center" alignItems="center">
                        <CircularProgress size={18} sx={{ opacity: isLoading ? 1 : 0 }} />
                        <Typography variant="h4" sx={STYLES.TABLE_DETAILS_TEXT}>
                            <b>{title}</b>
                        </Typography>
                    </Stack>
                    <P8PDataGrid
                        {...{ ...P8P_DATA_GRID_CONFIG_PROPS, noDataFoundText: isLoading || !data.init ? "" : noDataFoundMessage }}
                        containerComponentProps={{ sx: STYLES.TABLE_DETAILS, elevation: 0 }}
                        columnsDef={data.columnsDef}
                        rows={data.rows}
                        size={P8P_DATA_GRID_SIZE.SMALL}
                        morePages={data.morePages}
                        morePagesBtnProps={{ sx: STYLES.TABLE_DETAILS_MORE_BUTTON }}
                        fixedHeader={true}
                        reloading={false}
                        dataCellRender={dataCellRender}
                        headCellRender={headCellRender}
                        onOrderChanged={handleOrderChanged}
                        onPagesCountChanged={handlePagesCountChanged}
                    />
                </>
            )}
        </Box>
    );
};

//Контроль свойств - Таблица детализации изделия
ProductDetailsTable.propTypes = {
    planSpec: PropTypes.number,
    product: PropTypes.number,
    stored: PropTypes.string.isRequired,
    noProductMessage: PropTypes.string.isRequired,
    noPlanSpecMessage: PropTypes.string.isRequired,
    noDataFoundMessage: PropTypes.string.isRequired,
    title: PropTypes.string.isRequired
};

//-----------
//Тело модуля
//-----------

//Детализация по объекту
const PlanSpecDetail = ({ planSpec, disableNavigatePrev = false, disableNavigateNext = false, onNavigate, onBack }) => {
    //Собственное состояние - данные производственных составов SVG
    const [costProductComposition, setCostProductComposition] = useCostProductComposition(planSpec.NRN);

    //Выбор элемента изделия
    const setProduct = product => {
        setCostProductComposition(pv => ({ ...pv, selectedProduct: product ? { ...product } : null }));
    };

    //При навигации между карточками
    const handleNavigate = direction => {
        setProduct(null);
        if (onNavigate) onNavigate(direction);
    };

    //Формируем представление
    return (
        <Container maxWidth={false} sx={STYLES.CARD_DETAILS_CONTAINER}>
            <Grid container direction="row" justifyContent="center" alignItems="center" spacing={0}>
                <Grid item display="flex" justifyContent="center" xs={1}>
                    <Stack display="flex" direction="row" justifyContent="flex-end" alignItems="center" sx={STYLES.CARD_DETAILS_NAVIGATION_STACK}>
                        <IconButton disabled={disableNavigatePrev} onClick={() => handleNavigate(-1)}>
                            <Icon sx={STYLES.NAVIGATE_BUTTONS}>navigate_before</Icon>
                        </IconButton>
                    </Stack>
                </Grid>
                <Grid item xs={10}>
                    <Container maxWidth={false}>
                        <Button onClick={() => (onBack ? onBack() : null)}>
                            <Stack direction="row" color="text.title.fontColor">
                                <Icon>chevron_left</Icon>Назад
                            </Stack>
                        </Button>

                        <Grid container spacing={2} sx={{ paddingTop: "5px" }}>
                            <Grid item xs={5}>
                                <Box sx={STYLES.BOX_INFO_MAIN}>
                                    <ProductDetailsTable
                                        planSpec={costProductComposition.selectedProduct?.NFCPRODPLANSP_LINK}
                                        product={costProductComposition.selectedProduct?.NRN}
                                        stored={"PKG_P8PANELS_MECHREC.FCROUTLST_DG_BY_LINKED_GET"}
                                        noProductMessage={"Укажите элемент модели, чтобы увидеть информацию о маршрутных картах"}
                                        noPlanSpecMessage={"Не определена связанная запись производственной программы"}
                                        noDataFoundMessage={"Маршрутные карты не найдены"}
                                        title={"Маршрутные карты"}
                                    />
                                </Box>
                                <Box sx={STYLES.BOX_INFO_MAIN} mt={2}>
                                    <ProductDetailsTable
                                        planSpec={costProductComposition.selectedProduct?.NFCPRODPLANSP_LINK}
                                        product={costProductComposition.selectedProduct?.NRN}
                                        stored={"PKG_P8PANELS_MECHREC.FCDELIVSH_DG_BY_LINKED_GET"}
                                        noProductMessage={"Укажите элемент модели, чтобы увидеть информацию о комплектовочных ведомостях"}
                                        noPlanSpecMessage={"Не определена связанная запись производственной программы"}
                                        noDataFoundMessage={"Комплектовочные ведомости не найдены"}
                                        title={"Дефицит комплектующих"}
                                    />
                                </Box>
                            </Grid>
                            <Grid item xs={7}>
                                <Box sx={STYLES.DETAIL_INFO}>
                                    <PlanSpecInfo planSpec={planSpec} />
                                </Box>
                                <Box sx={STYLES.PRODUCT_SELECTOR_CONTAINER}>
                                    <PlanSpecProductCompositionModel
                                        model={costProductComposition.model}
                                        products={costProductComposition.products}
                                        onProductSelect={setProduct}
                                    />
                                </Box>
                            </Grid>
                        </Grid>
                    </Container>
                </Grid>
                <Grid item display="flex" justifyContent="center" xs={1}>
                    <Stack display="flex" direction="row" justifyContent="flex-start" alignItems="center" sx={STYLES.CARD_DETAILS_NAVIGATION_STACK}>
                        <IconButton disabled={disableNavigateNext} onClick={() => handleNavigate(1)}>
                            <Icon sx={STYLES.NAVIGATE_BUTTONS}>navigate_next</Icon>
                        </IconButton>
                    </Stack>
                </Grid>
            </Grid>
        </Container>
    );
};

//Контроль свойств - Детализация по объекту
PlanSpecDetail.propTypes = {
    planSpec: PropTypes.object,
    disableNavigatePrev: PropTypes.bool,
    disableNavigateNext: PropTypes.bool,
    onNavigate: PropTypes.func,
    onBack: PropTypes.func
};

//----------------
//Интерфейс модуля
//----------------

export { PlanSpecDetail };
