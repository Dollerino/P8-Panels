/*
    Парус 8 - Панели мониторинга - ПУП - Выдача сменного задания
    Компонент панели: Таблица информации о строках сменного задания
*/

//---------------------
//Подключение библиотек
//---------------------

import React, { useState } from "react"; //Классы React
import PropTypes from "prop-types"; //Контроль свойств компонента
import { Typography, Box, Checkbox, Grid, Icon, Button, Dialog, DialogContent, TextField, DialogActions, Tooltip } from "@mui/material"; //Интерфейсные элементы
import { P8PDataGrid, P8P_DATA_GRID_SIZE } from "../../components/p8p_data_grid"; //Таблица данных
import { P8P_DATA_GRID_CONFIG_PROPS } from "../../config_wrapper"; //Подключение компонентов к настройкам приложения
import { useCostJobsSpecs, useEquipConfiguration } from "./hooks"; //Собственные хуки таблиц

//---------
//Константы
//---------
const sUnitCostJobsSpecs = "CostJobsSpecs"; //Мнемокод раздела операций
const sUnitCostEquipment = "CostEquipment"; //Мнемокод раздела рабочих центров

//Стили
const STYLES = {
    CONTAINER: { textAlign: "center" },
    DATA_GRID_CONTAINER: { minHeight: "65vh", maxHeight: "65vh" },
    TABLE: { paddingTop: "15px" },
    TABLE_BUTTONS: { display: "flex", justifyContent: "flex-end" },
    CHECK_BOX: { textAlign: "center" },
    JOBS_INFO: { minWidth: "60%", maxWidth: "60%", textAlign: "center" },
    EQUIPMENT_INFO: { minWidth: "40%", maxWidth: "40%", textAlign: "center" }
};

//Цвета
const colors = {
    LINKED: "#bce0de",
    UNAVAILABLE: "#949494",
    WITH_EQCONFIG: "#82df83"
};

//---------------------------------------------
//Вспомогательные функции и компоненты
//---------------------------------------------

//Форматирование значения ячейки
const dataCellRender = ({ row, columnDef, handleSelectChange, sUnit, selectedRow, selectedJobSpec }) => {
    //Стиль
    let cellStyle = {};
    //Если это рабочие центры
    if (sUnit === sUnitCostEquipment) {
        //Признак недоступности
        let disabled = true;
        //Если в выбранной строке смены указано рабочее место
        if (selectedJobSpec.NEQCONFIG) {
            //Если это текущее рабочее место
            if (row["NRN"] === selectedJobSpec.NEQCONFIG) {
                //Подсвечиваем строку рабочего места
                cellStyle = { backgroundColor: colors.LINKED };
            }
        } else {
            //Если выбрана строка смены
            if (selectedJobSpec.NRN) {
                //Если на текущее рабочее место возможно добавить задание
                if (row["NLOADING"] < 100 && row["NEQUIPMENT"] === selectedJobSpec.NEQUIP_PLAN) {
                    //Подсвечиваем строку рабочего места
                    cellStyle = { backgroundColor: colors.LINKED };
                    disabled = false;
                }
            }
        }
        //Если рабочий центр загружен
        if (row["NLOADING"] >= 100) {
            //Если поле не поле выбора
            if (columnDef.name !== "NSELECT") {
                //Указываем, что рабочее место недоступно
                cellStyle = { ...cellStyle, color: colors.UNAVAILABLE };
            }
        }
        //Для колонки выбора
        if (columnDef.name === "NSELECT") {
            return {
                cellStyle,
                data: (
                    <Box sx={STYLES.CHECK_BOX}>
                        <Checkbox
                            disabled={disabled}
                            checked={row["NRN"] === selectedRow}
                            onChange={() => handleSelectChange({ NRN: row["NRN"], SUNIT: sUnit, BFULL_LOADED: row["NLOADING"] >= 100 })}
                        />
                    </Box>
                )
            };
        }
        //Отформатированная колонка
        return {
            cellStyle,
            data: row[columnDef.name]
        };
    }
    //Если это сменное задание
    if (sUnit === sUnitCostJobsSpecs) {
        //Если указан станок
        if (row["SEQCONFIG"]) {
            //Подсвечиваем сменное задание зеленым
            cellStyle = { ...cellStyle, backgroundColor: colors.WITH_EQCONFIG };
        }
        //Для колонки выбора
        if (columnDef.name === "NSELECT") {
            return {
                cellStyle,
                data: (
                    <Box sx={STYLES.CHECK_BOX}>
                        <Checkbox
                            disabled={row["DBEG_FACT"] ? true : false}
                            checked={row["NRN"] === selectedRow}
                            onChange={() =>
                                handleSelectChange({
                                    NRN: row["NRN"],
                                    SUNIT: sUnit,
                                    NEQCONFIG: row["NEQCONFIG"],
                                    NEQUIP_PLAN: row["NEQUIP_PLAN"],
                                    NQUANT_PLAN: row["NQUANT_PLAN"]
                                })
                            }
                        />
                    </Box>
                )
            };
        }
        //Отформатированная колонка
        return {
            cellStyle,
            data: row[columnDef.name]
        };
    }
    //Необрабатываемый раздел
    return {
        data: row[columnDef.name]
    };
};

//Генерация представления ячейки заголовка группы
export const headCellRender = ({ columnDef }) => {
    if (columnDef.name === "NSELECT") {
        return {
            stackStyle: { padding: "2px", justifyContent: "space-around" },
            data: <Icon>done</Icon>
        };
    } else {
        return {
            stackStyle: { padding: "2px" },
            data: columnDef.caption
        };
    }
};

//Диалог включения станка в сменное задание
const CostJobsSpecsInclude = ({ includeEquipment, setIncludeEquipment, setCostJobsSpecs, setEquipConfiguration, includeEquipConfiguration }) => {
    //Собственное состояние - Значение приоритета
    const [state, setState] = useState(includeEquipment.NVALUE);

    //При закрытии включения станка
    const handlePriorEditClose = () => {
        setIncludeEquipment({
            NFCJOBSSP: null,
            NEQCONFIG: null,
            NVALUE: 0
        });
    };

    //При включении станка в строку сменного задания
    const costJobsSpecIncludeCostEquipment = () => {
        //Делаем асинхронно, чтобы при ошибке ничего не обновлять
        const includeAsync = async () => {
            //Включаем станок в строку сменного задания
            try {
                await includeEquipConfiguration({
                    NEQCONFIG: includeEquipment.NEQCONFIG,
                    NFCJOBSSP: includeEquipment.NFCJOBSSP,
                    NQUANT_PLAN: state
                });
                //Необходимо обновить все данные
                setCostJobsSpecs(pv => ({ ...pv, selectedRow: {}, pageNumber: 1, reload: true }));
                setEquipConfiguration(pv => ({ ...pv, selectedRow: {}, pageNumber: 1, reload: true }));
                handlePriorEditClose();
            } catch (e) {
                throw new Error(e.message);
            }
        };
        //Включаем станок асинхронно
        includeAsync();
    };

    return (
        <Dialog open onClose={() => handlePriorEditClose()}>
            <DialogContent>
                <Box>
                    <TextField
                        name="editInculdeValue"
                        label="Количество"
                        variant="standard"
                        fullWidth
                        InputProps={{
                            type: "number",
                            inputProps: {
                                max: includeEquipment.NVALUE,
                                min: 0
                            }
                        }}
                        value={state}
                        onChange={event => {
                            var value = parseInt(event.target.value, 10);
                            if (value > includeEquipment.NVALUE) {
                                value = includeEquipment.NVALUE;
                            }
                            if (value < 0) {
                                value = 0;
                            }
                            setState(value);
                        }}
                    />
                    <Box>
                        <Button onClick={costJobsSpecIncludeCostEquipment} variant="contained" sx={STYLES.DIALOG_BUTTONS}>
                            Включить в задание
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

//Контроль свойств - Диалог включения станка в сменное задание
CostJobsSpecsInclude.propTypes = {
    includeEquipment: PropTypes.object.isRequired,
    setIncludeEquipment: PropTypes.func.isRequired,
    setCostJobsSpecs: PropTypes.func.isRequired,
    setEquipConfiguration: PropTypes.func.isRequired,
    includeEquipConfiguration: PropTypes.func.isRequired
};

//-----------
//Тело модуля
//-----------

//Таблица информации о строках сменного задания
const CostJobsSpecsDataGrid = ({ task, haveNote }) => {
    //Собственное состояние - Включение в задание
    const [includeEquipment, setIncludeEquipment] = useState({ NFCJOBSSP: null, NEQCONFIG: null, NVALUE: 0 });

    //Собственное состояние - таблица данных сменных заданий
    const [costJobsSpecs, setCostJobsSpecs, issueCostJobsSpecs] = useCostJobsSpecs(task);

    //Собственное состояние - таблица рабочих центров
    const [equipConfiguration, setEquipConfiguration, includeEquipConfiguration, excludeEquipConfiguration] = useEquipConfiguration(task);

    //При изменении состояния сортировки операций
    const costJobsSpecOrderChanged = ({ orders }) => setCostJobsSpecs(pv => ({ ...pv, orders: [...orders], pageNumber: 1, reload: true }));

    //При изменении количества отображаемых страниц операций
    const costJobsSpecPagesCountChanged = () => setCostJobsSpecs(pv => ({ ...pv, pageNumber: pv.pageNumber + 1, reload: true }));

    //При изменении состояния сортировки рабочих центров
    const costEquipmentOrderChanged = ({ orders }) => setEquipConfiguration(pv => ({ ...pv, orders: [...orders], pageNumber: 1, reload: true }));

    //При изменении количества отображаемых страниц рабочих центров
    const costEquipmentPagesCountChanged = () => setEquipConfiguration(pv => ({ ...pv, pageNumber: pv.pageNumber + 1, reload: true }));

    //При исключении станка из строки сменного задания
    const costJobsSpecExcludeCostEquipment = () => {
        //Делаем асинхронно, чтобы при ошибке ничего не обновлять
        const excludeAsync = async () => {
            //Исключаем станок из строки сменного задания
            try {
                await excludeEquipConfiguration({
                    NFCJOBSSP: costJobsSpecs.selectedRow.NRN
                });
                //Необходимо обновить данные
                setCostJobsSpecs(pv => ({ ...pv, selectedRow: {}, pageNumber: 1, reload: true }));
                setEquipConfiguration(pv => ({ ...pv, selectedRow: {}, pageNumber: 1, reload: true }));
            } catch (e) {
                throw new Error(e.message);
            }
        };
        //Исключаем станок асинхронно
        excludeAsync();
    };

    //Выдача задания операции
    const costJobsSpecIssue = () => {
        //Делаем асинхронно, чтобы при ошибке ничего не обновлять
        const issueAsync = async () => {
            //Включаем оборудование в операции
            try {
                await issueCostJobsSpecs({ NFCJOBS: task });
                //Необходимо обновить данные
                setCostJobsSpecs(pv => ({ ...pv, selectedRow: {}, pageNumber: 1, reload: true }));
                setEquipConfiguration(pv => ({ ...pv, selectedRow: {}, pageNumber: 1, reload: true }));
            } catch (e) {
                throw new Error(e.message);
            }
        };
        //Выдаем задание асинхронно
        issueAsync();
    };

    //При изменение состояния выбора
    const handleSelectChange = prms => {
        //Выбранный элемент
        let selectedRow = null;
        //Исходим от раздела
        switch (prms.SUNIT) {
            //Сменное задание
            case sUnitCostJobsSpecs:
                //Определяем это новое отмеченное сменное задание или сброс старого
                selectedRow = costJobsSpecs.selectedRow.NRN ? (costJobsSpecs.selectedRow.NRN === prms.NRN ? null : prms.NRN) : prms.NRN;
                //Актуализируем строки
                setCostJobsSpecs(pv => ({
                    ...pv,
                    selectedRow: selectedRow
                        ? { NRN: selectedRow, NEQCONFIG: prms.NEQCONFIG, NEQUIP_PLAN: prms.NEQUIP_PLAN, NQUANT_PLAN: prms.NQUANT_PLAN }
                        : { NRN: null, NEQCONFIG: null, NEQUIP_PLAN: null, NQUANT_PLAN: null }
                }));
                //Выходим
                break;
            //Рабочие центры
            case sUnitCostEquipment:
                //Определяем это новое отмеченное сменное задание или сброс старого
                selectedRow = equipConfiguration.selectedRow.NRN ? (equipConfiguration.selectedRow.NRN === prms.NRN ? null : prms.NRN) : prms.NRN;
                //Актуализируем строки
                setEquipConfiguration(pv => ({
                    ...pv,
                    selectedRow: selectedRow ? { NRN: selectedRow, BFULL_LOADED: prms.BFULL_LOADED } : { NRN: null, BFULL_LOADED: null }
                }));
                //Выходим
                break;
            default:
                return;
        }
    };

    //При открытии окна включения в задание
    const handleIncludeEquipmentOpen = () => {
        //Актуализируем строки
        setIncludeEquipment({
            NFCJOBSSP: costJobsSpecs.selectedRow.NRN,
            NEQCONFIG: equipConfiguration.selectedRow.NRN,
            NVALUE: costJobsSpecs.selectedRow.NQUANT_PLAN
        });
    };

    //Генерация содержимого
    return (
        <div style={STYLES.CONTAINER}>
            <Grid container spacing={2}>
                <Grid item sx={STYLES.JOBS_INFO}>
                    <Typography variant={"h6"}>Сменное задание</Typography>
                    {costJobsSpecs.dataLoaded ? (
                        <>
                            <Box sx={STYLES.TABLE_BUTTONS}>
                                <Tooltip title={haveNote ? "Сменное задание имеет строку с примечанием" : null}>
                                    <Box>
                                        <Button variant="contained" size="small" disabled={haveNote} onClick={costJobsSpecIssue}>
                                            Выдать задания
                                        </Button>
                                    </Box>
                                </Tooltip>
                            </Box>
                            <Box sx={STYLES.TABLE}>
                                <P8PDataGrid
                                    {...P8P_DATA_GRID_CONFIG_PROPS}
                                    containerComponentProps={{ sx: STYLES.DATA_GRID_CONTAINER, elevation: 1 }}
                                    columnsDef={costJobsSpecs.columnsDef}
                                    rows={costJobsSpecs.rows}
                                    size={P8P_DATA_GRID_SIZE.SMALL}
                                    morePages={costJobsSpecs.morePages}
                                    reloading={costJobsSpecs.reload}
                                    onOrderChanged={costJobsSpecOrderChanged}
                                    onPagesCountChanged={costJobsSpecPagesCountChanged}
                                    dataCellRender={prms =>
                                        dataCellRender({
                                            ...prms,
                                            handleSelectChange,
                                            sUnit: sUnitCostJobsSpecs,
                                            selectedRow: costJobsSpecs.selectedRow.NRN,
                                            selectedJobSpec: costJobsSpecs.selectedRow
                                        })
                                    }
                                    headCellRender={prms => headCellRender({ ...prms })}
                                    fixedHeader={true}
                                />
                            </Box>
                        </>
                    ) : null}
                </Grid>
                <Grid item sx={STYLES.EQUIPMENT_INFO}>
                    <Typography variant={"h6"}>Рабочие центры</Typography>
                    {equipConfiguration.dataLoaded ? (
                        <>
                            <Box sx={STYLES.TABLE_BUTTONS}>
                                <Button
                                    variant="contained"
                                    size="small"
                                    disabled={
                                        !equipConfiguration.selectedRow.NRN ||
                                        !costJobsSpecs.selectedRow.NRN ||
                                        (equipConfiguration.selectedRow.NRN && equipConfiguration.selectedRow.BFULL_LOADED)
                                    }
                                    onClick={handleIncludeEquipmentOpen}
                                >
                                    Включить в задание
                                </Button>
                                <Box ml={1}>
                                    <Button
                                        variant="contained"
                                        size="small"
                                        disabled={!costJobsSpecs.selectedRow.NRN || !costJobsSpecs.selectedRow.NEQCONFIG}
                                        onClick={costJobsSpecExcludeCostEquipment}
                                    >
                                        Исключить из задания
                                    </Button>
                                </Box>
                            </Box>
                            <Box sx={STYLES.TABLE}>
                                <P8PDataGrid
                                    {...P8P_DATA_GRID_CONFIG_PROPS}
                                    containerComponentProps={{ sx: STYLES.DATA_GRID_CONTAINER, elevation: 1 }}
                                    columnsDef={equipConfiguration.columnsDef}
                                    rows={equipConfiguration.rows}
                                    size={P8P_DATA_GRID_SIZE.SMALL}
                                    morePages={equipConfiguration.morePages}
                                    reloading={equipConfiguration.reload}
                                    onOrderChanged={costEquipmentOrderChanged}
                                    onPagesCountChanged={costEquipmentPagesCountChanged}
                                    dataCellRender={prms =>
                                        dataCellRender({
                                            ...prms,
                                            handleSelectChange,
                                            sUnit: sUnitCostEquipment,
                                            selectedRow: equipConfiguration.selectedRow.NRN,
                                            selectedJobSpec: costJobsSpecs.selectedRow
                                        })
                                    }
                                    headCellRender={prms => headCellRender({ ...prms })}
                                    fixedHeader={true}
                                />
                            </Box>
                        </>
                    ) : null}
                </Grid>
            </Grid>
            {includeEquipment.NFCJOBSSP && includeEquipment.NFCJOBSSP ? (
                <CostJobsSpecsInclude
                    includeEquipment={includeEquipment}
                    setIncludeEquipment={setIncludeEquipment}
                    setCostJobsSpecs={setCostJobsSpecs}
                    setEquipConfiguration={setEquipConfiguration}
                    includeEquipConfiguration={includeEquipConfiguration}
                />
            ) : null}
        </div>
    );
};

//Контроль свойств - Таблица информации о строках сменного задания
CostJobsSpecsDataGrid.propTypes = {
    task: PropTypes.number.isRequired,
    haveNote: PropTypes.bool.isRequired
};

//----------------
//Интерфейс модуля
//----------------

export { CostJobsSpecsDataGrid };
