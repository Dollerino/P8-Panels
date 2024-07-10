/*
    Парус 8 - Панели мониторинга - ПУП - Загрузка цеха
    Компонент панели: Фильтр
*/

//---------------------
//Подключение библиотек
//---------------------

import React from "react"; //Классы React
import PropTypes from "prop-types"; //Контроль свойств компонента
import {
    Typography,
    Box,
    Dialog,
    DialogContent,
    DialogActions,
    Button,
    IconButton,
    Icon,
    FormControl,
    InputLabel,
    OutlinedInput,
    InputAdornment
} from "@mui/material"; //Интерфейсные элементы
import { InsDepartmentDataGrid } from "./ins_department_dg"; //Таблица подразделений цехов

//---------
//Константы
//---------

//Текущая дата
const currentDate = new Date();
const currentMonth = currentDate.getUTCMonth() + 1;
const currentYear = currentDate.getUTCFullYear();

//Стили
const STYLES = {
    FILTER_BLOCK: { maxWidth: "200px" }
};

//------------------------------------
//Вспомогательные функции и компоненты
//------------------------------------

//Диалог выбора подразделения
const DepartmentsDataGrid = ({ filter, setFilter, handleSelectDeparture }) => {
    return (
        <Dialog fullWidth open onClose={() => setFilter(pv => ({ ...pv, openedDepartment: false }))}>
            <DialogContent>
                <InsDepartmentDataGrid fullDate={filter.date.fullDate} handleSelectDeparture={handleSelectDeparture} />
            </DialogContent>
            <DialogActions>
                <Button onClick={() => setFilter(pv => ({ ...pv, openedDepartment: false }))}>Закрыть</Button>
            </DialogActions>
        </Dialog>
    );
};

//Контроль свойств - Диалог выбора подразделения
DepartmentsDataGrid.propTypes = {
    filter: PropTypes.object.isRequired,
    setFilter: PropTypes.func.isRequired,
    handleSelectDeparture: PropTypes.func.isRequired
};

//-----------
//Тело модуля
//-----------

//Компонент фильтра
const FilterComponent = ({ filter, setFilter, handleMonthChange, handleSelectDeparture }) => {
    return (
        <Box display="flex" flexDirection="row" justifyContent="flex-start" alignItems="flex-end" pt={1.5} pl={1}>
            <FormControl sx={STYLES.FILTER_BLOCK} readOnly fullWidth variant="outlined">
                <InputLabel required={!filter.department.SCODE} htmlFor="department-outlined">
                    Цех
                </InputLabel>
                <OutlinedInput
                    disabled
                    id="department-outlined"
                    value={filter.department.SCODE}
                    endAdornment={
                        <InputAdornment position="end">
                            <IconButton
                                aria-label="department select"
                                onClick={() => setFilter(pv => ({ ...pv, openedDepartment: true }))}
                                edge="end"
                            >
                                <Icon>list</Icon>
                            </IconButton>
                        </InputAdornment>
                    }
                    aria-describedby="department-outlined-helper-text"
                    label="Цех"
                />
            </FormControl>
            <Box sx={STYLES.FILTER_BLOCK} display="flex" pb={1}>
                <Box>
                    <IconButton onClick={() => handleMonthChange(-1)}>
                        <Icon>navigate_before</Icon>
                    </IconButton>
                </Box>
                <Typography variant="h5" pt={0.5}>
                    {filter.date.fullDate}
                </Typography>
                <Box>
                    <IconButton
                        onClick={() => handleMonthChange(1)}
                        disabled={filter.date.year === currentYear && filter.date.month === currentMonth}
                    >
                        <Icon>navigate_next</Icon>
                    </IconButton>
                </Box>
            </Box>
            <Typography variant="subtitle2" pl={2} pb={2}>{`Рабочих дней: ${filter.workDays}`}</Typography>
            <Typography variant="subtitle2" pl={3.5} pb={2}>{`Рабочих часов: ${filter.totalWorkHours}`}</Typography>
            {filter.openedDepartment ? (
                <DepartmentsDataGrid filter={filter} setFilter={setFilter} handleSelectDeparture={handleSelectDeparture} />
            ) : null}
        </Box>
    );
};

//Контроль свойств - Компонент фильтра
FilterComponent.propTypes = {
    filter: PropTypes.object.isRequired,
    setFilter: PropTypes.func.isRequired,
    handleMonthChange: PropTypes.func.isRequired,
    handleSelectDeparture: PropTypes.func.isRequired
};

//----------------
//Интерфейс модуля
//----------------

export { FilterComponent };
