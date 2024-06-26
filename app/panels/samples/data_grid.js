/*
    Парус 8 - Панели мониторинга - Примеры для разработчиков
    Пример: Таблица данных "P8PDataGrid"
*/

//---------------------
//Подключение библиотек
//---------------------

import React, { useState, useContext, useCallback, useEffect } from "react"; //Классы React
import PropTypes from "prop-types"; //Контроль свойств компонента
import { Typography, Grid, Stack, Icon, Box, Button } from "@mui/material"; //Интерфейсные элементы
import { object2Base64XML } from "../../core/utils"; //Вспомогательные процедуры и функции
import { P8PDataGrid, P8P_DATA_GRID_SIZE } from "../../components/p8p_data_grid"; //Таблица данных
import { P8P_DATA_GRID_CONFIG_PROPS } from "../../config_wrapper"; //Подключение компонентов к настройкам приложения
import { BackEndСtx } from "../../context/backend"; //Контекст взаимодействия с сервером
import { ApplicationСtx } from "../../context/application"; //Контекст приложения

//---------
//Константы
//---------

//Размер страницы данных
const DATA_GRID_PAGE_SIZE = 5;

//Стили
const STYLES = {
    CONTAINER: { textAlign: "center", paddingTop: "20px" },
    TITLE: { paddingBottom: "15px" },
    DATA_GRID_CONTAINER: { maxWidth: 700, maxHeight: 500, minHeight: 500 }
};

//---------------------------------------------
//Вспомогательные функции форматирования данных
//---------------------------------------------

//Формирование значения для колонки "Тип контрагента"
const formatAgentTypeValue = (value, addText = false) => {
    const [text, icon] = value == 0 ? ["Юридическое лицо", "business"] : ["Физическое лицо", "person"];
    return (
        <Stack direction="row" gap={0.5} alignItems="center" justifyContent="center">
            <Icon title={text}>{icon}</Icon>
            {addText == true ? text : null}
        </Stack>
    );
};

//Форматирование значений колонок
const valueFormatter = ({ value, columnDef }) => {
    switch (columnDef.name) {
        case "NAGNTYPE":
            return formatAgentTypeValue(value, true);
    }
    return value;
};

//Генерация представления ячейки c данными
const dataCellRender = ({ row, columnDef }) => {
    switch (columnDef.name) {
        case "NAGNTYPE":
            return {
                cellProps: { align: "center" },
                data: formatAgentTypeValue(row[columnDef.name], false)
            };
    }
};

//Генерация представления ячейки заголовка
const headCellRender = ({ columnDef }) => {
    switch (columnDef.name) {
        case "NAGNTYPE":
            return {
                stackProps: { justifyContent: "center" },
                cellProps: { align: "center" }
            };
    }
};

//Генерация представления ячейки заголовка группы
export const groupCellRender = () => ({ cellStyle: { padding: "2px" } });

//-----------
//Тело модуля
//-----------

//Пример: Таблица данных "P8PDataGrid"
const DataGrid = ({ title }) => {
    //Собственное состояние - таблица данных
    const [dataGrid, setdataGrid] = useState({
        dataLoaded: false,
        columnsDef: [],
        filters: null,
        orders: null,
        groups: [],
        rows: [],
        reload: true,
        pageNumber: 1,
        morePages: true,
        fixedHeader: false,
        fixedColumns: 0
    });

    //Подключение к контексту взаимодействия с сервером
    const { executeStored, SERV_DATA_TYPE_CLOB } = useContext(BackEndСtx);

    //Подключение к контексту приложения
    const { pOnlineShowDocument } = useContext(ApplicationСtx);

    //Загрузка данных таблицы с сервера
    const loadData = useCallback(async () => {
        if (dataGrid.reload) {
            const data = await executeStored({
                stored: "PKG_P8PANELS_SAMPLES.DATA_GRID",
                args: {
                    CFILTERS: { VALUE: object2Base64XML(dataGrid.filters, { arrayNodeName: "filters" }), SDATA_TYPE: SERV_DATA_TYPE_CLOB },
                    CORDERS: { VALUE: object2Base64XML(dataGrid.orders, { arrayNodeName: "orders" }), SDATA_TYPE: SERV_DATA_TYPE_CLOB },
                    NPAGE_NUMBER: dataGrid.pageNumber,
                    NPAGE_SIZE: DATA_GRID_PAGE_SIZE,
                    NINCLUDE_DEF: dataGrid.dataLoaded ? 0 : 1
                },
                respArg: "COUT"
            });
            setdataGrid(pv => ({
                ...pv,
                fixedHeader: data.XDATA_GRID.fixedHeader,
                fixedColumns: data.XDATA_GRID.fixedColumns,
                columnsDef: data.XCOLUMNS_DEF ? [...data.XCOLUMNS_DEF] : pv.columnsDef,
                rows: pv.pageNumber == 1 ? [...(data.XROWS || [])] : [...pv.rows, ...(data.XROWS || [])],
                groups: data.XGROUPS
                    ? pv.pageNumber == 1
                        ? [...data.XGROUPS]
                        : [...pv.groups, ...data.XGROUPS.filter(g => !pv.groups.find(pg => pg.name == g.name))]
                    : [...pv.groups],
                dataLoaded: true,
                reload: false,
                morePages: (data.XROWS || []).length >= DATA_GRID_PAGE_SIZE
            }));
        }
    }, [dataGrid.reload, dataGrid.filters, dataGrid.orders, dataGrid.dataLoaded, dataGrid.pageNumber, executeStored, SERV_DATA_TYPE_CLOB]);

    //При изменении состояния фильтра
    const handleFilterChanged = ({ filters }) => setdataGrid(pv => ({ ...pv, filters: [...filters], pageNumber: 1, reload: true }));

    //При изменении состояния сортировки
    const handleOrderChanged = ({ orders }) => setdataGrid(pv => ({ ...pv, orders: [...orders], pageNumber: 1, reload: true }));

    //При изменении количества отображаемых страниц
    const handlePagesCountChanged = () => setdataGrid(pv => ({ ...pv, pageNumber: pv.pageNumber + 1, reload: true }));

    //При нажатии на копку контрагента
    const handleAgnButtonClicked = agnCode => pOnlineShowDocument({ unitCode: "AGNLIST", document: agnCode, inRnParameter: "in_AGNABBR" });

    //При необходимости обновить данные таблицы
    useEffect(() => {
        loadData();
    }, [dataGrid.reload, loadData]);

    //Генерация содержимого
    return (
        <div style={STYLES.CONTAINER}>
            <Typography sx={STYLES.TITLE} variant={"h6"}>
                {title}
            </Typography>
            <Grid container spacing={1} pt={5}>
                <Grid item xs={12}>
                    <Box p={5} display="flex" justifyContent="center" alignItems="center">
                        {dataGrid.dataLoaded ? (
                            <P8PDataGrid
                                {...P8P_DATA_GRID_CONFIG_PROPS}
                                containerComponentProps={{ elevation: 6, style: STYLES.DATA_GRID_CONTAINER }}
                                columnsDef={dataGrid.columnsDef}
                                groups={dataGrid.groups}
                                rows={dataGrid.rows}
                                size={P8P_DATA_GRID_SIZE.LARGE}
                                fixedHeader={dataGrid.fixedHeader}
                                fixedColumns={dataGrid.fixedColumns}
                                filtersInitial={dataGrid.filters}
                                morePages={dataGrid.morePages}
                                reloading={dataGrid.reload}
                                valueFormatter={valueFormatter}
                                headCellRender={headCellRender}
                                dataCellRender={dataCellRender}
                                groupCellRender={groupCellRender}
                                onOrderChanged={handleOrderChanged}
                                onFilterChanged={handleFilterChanged}
                                onPagesCountChanged={handlePagesCountChanged}
                                expandable={true}
                                rowExpandRender={({ row }) => (
                                    <Button onClick={() => handleAgnButtonClicked(row.SAGNABBR)}>Показать в разделе</Button>
                                )}
                            />
                        ) : null}
                    </Box>
                </Grid>
            </Grid>
        </div>
    );
};

//Контроль свойств - Пример: Таблица данных "P8PDataGrid"
DataGrid.propTypes = {
    title: PropTypes.string.isRequired
};

//----------------
//Интерфейс модуля
//----------------

export { DataGrid };
