/*
    Парус 8 - Панели мониторинга - ПУП - Производственный план цеха
    Компонент панели: Таблица маршрутных листов
*/

//---------------------
//Подключение библиотек
//---------------------

import React, { useState, useContext } from "react"; //Классы React
import PropTypes from "prop-types"; //Контроль свойств компонента
import { Typography, Box, Paper, Dialog, DialogContent, DialogActions, Button, TextField, IconButton, Icon } from "@mui/material"; //Интерфейсные элементы
import { P8PDataGrid, P8P_DATA_GRID_SIZE } from "../../components/p8p_data_grid"; //Таблица данных
import { P8P_DATA_GRID_CONFIG_PROPS } from "../../config_wrapper"; //Подключение компонентов к настройкам приложения
import { BackEndСtx } from "../../context/backend"; //Контекст взаимодействия с сервером
import { CostRouteListsSpecsDataGrid } from "./fcroutlstsp"; //Состояние таблицы заказов маршрутных листов
import { useCostRouteLists } from "./hooks.js"; //Хук состояния таблицы маршрутных листов

//---------
//Константы
//---------

//Стили
const STYLES = {
    CONTAINER: { textAlign: "center" },
    TABLE: { paddingTop: "15px" },
    DIALOG_BUTTONS: { marginTop: "10px", width: "240px" }
};

//---------------------------------------------
//Вспомогательные функции и компоненты
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
    //Если колонка "Приоритет партии"
    if (columnDef.name === "NPRIOR_PARTY") {
        return {
            data: (
                <>
                    {row["NPRIOR_PARTY"]}
                    <IconButton edge="end" title="Изменить приоритет" onClick={() => handlePriorEditOpen(row["NRN"])}>
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

//Диалог с изменением приоритета маршрутного листа
const CostRouteListPriorChange = ({ costRouteLists, setCostRouteLists, executeStored }) => {
    //Считывание изначального значения приоритета МЛ
    const initPrior = costRouteLists.rows[costRouteLists.rows.findIndex(obj => obj.NRN == costRouteLists.editPriorNRN)].NPRIOR_PARTY;

    //Собственное состояние - Значение приоритета
    const [state, setState] = useState(initPrior);

    //При закрытии изменения приоритета партии
    const handlePriorEditClose = () => {
        setCostRouteLists(pv => ({ ...pv, editPriorNRN: null }));
    };

    //При нажатии на изменение приоритета партии
    const handlePriorChange = () => {
        //Асинхронное изменение
        const asyncChange = async (NRN, PriorValue, rows) => {
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
        };
        //Изменяем значение
        asyncChange(costRouteLists.editPriorNRN, state, costRouteLists.rows);
    };

    return (
        <Dialog open onClose={() => handlePriorEditClose()}>
            <DialogContent>
                <Box>
                    <TextField
                        name="editPriorValue"
                        label="Новое значение приоритета"
                        variant="standard"
                        fullWidth
                        type="number"
                        value={state}
                        onChange={event => {
                            setState(event.target.value);
                        }}
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
    );
};

//Контроль свойств - Диалог с изменением приоритета маршрутного листа
CostRouteListPriorChange.propTypes = {
    costRouteLists: PropTypes.object.isRequired,
    setCostRouteLists: PropTypes.func.isRequired,
    executeStored: PropTypes.func.isRequired
};

//-----------
//Тело модуля
//-----------

//Таблица маршрутных листов
const CostRouteListsDataGrid = ({ task }) => {
    //Собственное состояние - таблица данных
    const [costRouteLists, setCostRouteLists] = useCostRouteLists(task);

    //Подключение к контексту взаимодействия с сервером
    const { executeStored } = useContext(BackEndСtx);

    //При изменении состояния сортировки
    const handleOrderChanged = ({ orders }) => setCostRouteLists(pv => ({ ...pv, orders: [...orders], pageNumber: 1, reload: true }));

    //При изменении количества отображаемых страниц
    const handlePagesCountChanged = () => setCostRouteLists(pv => ({ ...pv, pageNumber: pv.pageNumber + 1, reload: true }));

    //При открытии изменения приоритета партии
    const handlePriorEditOpen = NRN => {
        setCostRouteLists(pv => ({ ...pv, editPriorNRN: NRN }));
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
                <CostRouteListPriorChange costRouteLists={costRouteLists} setCostRouteLists={setCostRouteLists} executeStored={executeStored} />
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
