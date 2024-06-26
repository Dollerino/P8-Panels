/*
    Парус 8 - Панели мониторинга - ПУП - Производственный план цеха
    Компонент панели: Таблица маршрутных листов
*/

//---------------------
//Подключение библиотек
//---------------------

import React, { useState, useCallback, useEffect, useContext } from "react"; //Классы React
import PropTypes from "prop-types"; //Контроль свойств компонента
import { Typography, Box, Paper, Dialog, DialogContent, DialogActions, Button, TextField, IconButton, Icon } from "@mui/material"; //Интерфейсные элементы
import { P8PDataGrid, P8P_DATA_GRID_SIZE } from "../../components/p8p_data_grid"; //Таблица данных
import { P8P_DATA_GRID_CONFIG_PROPS } from "../../config_wrapper"; //Подключение компонентов к настройкам приложения
import { BackEndСtx } from "../../context/backend"; //Контекст взаимодействия с сервером
import { object2Base64XML } from "../../core/utils"; //Вспомогательные функции
import { CostRouteListsSpecsDataGrid } from "./fcroutlstsp"; //Состояние таблицы заказов маршрутных листов

//---------
//Константы
//---------

//Стили
const STYLES = {
    CONTAINER: { textAlign: "center" },
    TABLE: { paddingTop: "15px" },
    TABLE_SUM: { textAlign: "right", paddingTop: "5px", paddingRight: "15px" },
    DIALOG_BUTTONS: { marginTop: "10px", width: "240px" }
};

//---------------------------------------------
//Вспомогательные функции форматирования данных
//---------------------------------------------

//Генерация представления расширения строки
export const rowExpandRender = ({ row }) => {
    return (
        <Paper elevation={4}>
            <CostRouteListsSpecsDataGrid mainRowRN={row.NRN} />
        </Paper>
    );
};

//Форматирование значений колонок
const dataCellRender = ({ row, columnDef, handlePriorEditOpen }) => {
    //!!! Пока отключено - не удалять
    switch (columnDef.name) {
        case "NPRIOR_PARTY":
            return {
                data: (
                    <>
                        {row["NPRIOR_PARTY"]}
                        <IconButton edge="end" title="Изменить приоритет" onClick={() => handlePriorEditOpen(row["NRN"], row["NPRIOR_PARTY"])}>
                            <Icon>edit</Icon>
                        </IconButton>
                    </>
                )
            };
    }
    return {
        data: row[columnDef]
    };
};

//-----------
//Тело модуля
//-----------

//Таблица маршрутных листов
const CostRouteListsDataGrid = ({ task }) => {
    //Собственное состояние - таблица данных
    const [costRouteLists, setCostRouteLists] = useState({
        dataLoaded: false,
        columnsDef: [],
        orders: null,
        rows: [],
        reload: true,
        pageNumber: 1,
        morePages: true,
        editPriorNRN: null,
        editPriorValue: null
    });

    //Подключение к контексту взаимодействия с сервером
    const { executeStored, SERV_DATA_TYPE_CLOB } = useContext(BackEndСtx);

    //Размер страницы данных
    const DATA_GRID_PAGE_SIZE = 5;

    //Загрузка данных таблицы с сервера
    const loadData = useCallback(async () => {
        if (costRouteLists.reload) {
            const data = await executeStored({
                stored: "PKG_P8PANELS_MECHREC.FCROUTLST_DEPT_DG_GET",
                args: {
                    NFCPRODPLANSP: task,
                    CORDERS: { VALUE: object2Base64XML(costRouteLists.orders, { arrayNodeName: "orders" }), SDATA_TYPE: SERV_DATA_TYPE_CLOB },
                    NPAGE_NUMBER: costRouteLists.pageNumber,
                    NPAGE_SIZE: DATA_GRID_PAGE_SIZE,
                    NINCLUDE_DEF: costRouteLists.dataLoaded ? 0 : 1
                },
                respArg: "COUT"
            });
            setCostRouteLists(pv => ({
                ...pv,
                columnsDef: data.XCOLUMNS_DEF ? [...data.XCOLUMNS_DEF] : pv.columnsDef,
                rows: pv.pageNumber == 1 ? [...(data.XROWS || [])] : [...pv.rows, ...(data.XROWS || [])],
                dataLoaded: true,
                reload: false,
                morePages: (data.XROWS || []).length >= DATA_GRID_PAGE_SIZE
            }));
        }
        // eslint-disable-next-line react-hooks/exhaustive-deps
    }, [
        costRouteLists.reload,
        costRouteLists.filters,
        costRouteLists.orders,
        costRouteLists.dataLoaded,
        costRouteLists.pageNumber,
        executeStored,
        SERV_DATA_TYPE_CLOB
    ]);

    //При необходимости обновить данные таблицы
    useEffect(() => {
        loadData();
    }, [costRouteLists.reload, loadData]);

    //При изменении состояния сортировки
    const handleOrderChanged = ({ orders }) => setCostRouteLists(pv => ({ ...pv, orders: [...orders], pageNumber: 1, reload: true }));

    //При изменении количества отображаемых страниц
    const handlePagesCountChanged = () => setCostRouteLists(pv => ({ ...pv, pageNumber: pv.pageNumber + 1, reload: true }));

    //При открытии изменения приоритета партии
    const handlePriorEditOpen = (NRN, nPriorValue) => {
        setCostRouteLists(pv => ({ ...pv, editPriorNRN: NRN, editPriorValue: nPriorValue }));
    };

    //При закрытии изменения приоритета партии
    const handlePriorEditClose = () => {
        setCostRouteLists(pv => ({ ...pv, editPriorNRN: null, editPriorValue: null }));
    };

    //При изменении значения приоритета партии
    const handlePriorFormChanged = e => {
        setCostRouteLists(pv => ({ ...pv, editPriorValue: e.target.value }));
    };

    //Изменение приоритета
    const priorChange = useCallback(
        async (NRN, PriorValue, rows) => {
            try {
                await executeStored({
                    stored: "PKG_P8PANELS_MECHREC.FCROUTLST_PRIOR_PARTY_UPDATE",
                    args: { NFCROUTLST: NRN, SPRIOR_PARTY: PriorValue }
                });
                //Изменяем значение приоритета у нужного
                rows[rows.findIndex(obj => obj.NRN == NRN)].NPRIOR_PARTY = PriorValue;
                //Актуализируем строки таблицы
                setCostRouteLists(pv => ({ ...pv, rows: rows }));
                //Закрываем окно
                handlePriorEditClose();
            } catch (e) {
                throw new Error(e.message);
            }
        },
        [executeStored]
    );

    //При нажатии на изменение приоритета партии
    const handlePriorChange = () => {
        //Изменяем значение
        priorChange(costRouteLists.editPriorNRN, costRouteLists.editPriorValue, costRouteLists.rows);
    };

    //Генерация содержимого
    return (
        <div style={STYLES.CONTAINER}>
            <Typography variant={"h6"}>В производстве</Typography>
            {costRouteLists.dataLoaded ? (
                <>
                    <Box sx={STYLES.TABLE}>
                        <P8PDataGrid
                            {...P8P_DATA_GRID_CONFIG_PROPS}
                            columnsDef={costRouteLists.columnsDef}
                            rows={costRouteLists.rows}
                            size={P8P_DATA_GRID_SIZE.LARGE}
                            morePages={costRouteLists.morePages}
                            reloading={costRouteLists.reload}
                            expandable={true}
                            rowExpandRender={rowExpandRender}
                            onOrderChanged={handleOrderChanged}
                            onPagesCountChanged={handlePagesCountChanged}
                            dataCellRender={prms => dataCellRender({ ...prms, handlePriorEditOpen })}
                        />
                    </Box>
                </>
            ) : null}
            {costRouteLists.editPriorNRN ? (
                <Dialog open onClose={() => handlePriorEditClose(null)}>
                    <DialogContent>
                        <Box>
                            <TextField
                                name="editPriorValue"
                                label="Новое значение приоритета"
                                variant="standard"
                                fullWidth
                                type="number"
                                value={costRouteLists.editPriorValue}
                                onChange={handlePriorFormChanged}
                            />
                            <Box>
                                <Button onClick={handlePriorChange} variant="contained" sx={STYLES.DIALOG_BUTTONS}>
                                    Изменить
                                </Button>
                            </Box>
                        </Box>
                    </DialogContent>
                    <DialogActions>
                        <Button onClick={() => handlePriorEditClose(null)}>Закрыть</Button>
                    </DialogActions>
                </Dialog>
            ) : null}
        </div>
    );
};

//Контроль свойств - Таблица маршрутных листов
CostRouteListsDataGrid.propTypes = {
    task: PropTypes.number.isRequired
};

//Диалог с таблицей сдачи продукции
const CostRouteListsDataGridDialog = ({ task, onClose }) => {
    return (
        <Dialog open onClose={onClose ? onClose : null} fullWidth maxWidth="xl">
            <DialogContent>
                <CostRouteListsDataGrid task={task} />
            </DialogContent>
            {onClose ? (
                <DialogActions>
                    <Button onClick={onClose}>Закрыть</Button>
                </DialogActions>
            ) : null}
        </Dialog>
    );
};

//Контроль свойств - Диалог с таблицей маршрутных листов
CostRouteListsDataGridDialog.propTypes = {
    task: PropTypes.number.isRequired,
    onClose: PropTypes.func
};

//----------------
//Интерфейс модуля
//----------------

export { CostRouteListsDataGridDialog };
