/*
    Парус 8 - Панели мониторинга - ПУП - Загрузка цеха
    Панель мониторинга: Корневая панель загрузки цеха
*/

//---------------------
//Подключение библиотек
//---------------------

import React from "react"; //Классы React
import { Typography, Box } from "@mui/material"; //Интерфейсные элементы
import { P8PDataGrid, P8P_DATA_GRID_SIZE } from "../../components/p8p_data_grid"; //Таблица данных
import { P8P_DATA_GRID_CONFIG_PROPS } from "../../config_wrapper"; //Подключение компонентов к настройкам приложения
import { useMechRecDeptCostJobs, useFilter } from "./hooks"; //Кастомные состояния
import { FilterComponent } from "./components/filter"; //Компонент фильтра

//---------
//Константы
//---------

//Текущая дата
const currentDate = new Date();
const currentMonth = currentDate.getUTCMonth() + 1;
const currentYear = currentDate.getUTCFullYear();

//Кастомные цвета
const colors = {
    lightred: "#ef8989",
    lightyellow: "#f5f5b0",
    blue: "#0097ff"
};

//Стили
const STYLES = {
    CONTAINER: { textAlign: "center", paddingTop: "10px" },
    TITLE: { paddingBottom: "15px" },
    DATA_GRID_CONTAINER: {
        minWidth: "700px",
        maxWidth: "100vw",
        minHeight: "calc(100vh - 250px)",
        maxHeight: "calc(100vh - 250px)"
    },
    DATA_GRID_CELL: (row, columnDef) => {
        //Определяем тип дня
        let dayType = columnDef.name.match(/N.*_VALUE/) ? row[`${columnDef.name.substring(0, 12)}_TYPE`] : null;
        //Определяем процент загрузки
        let procentLoad = columnDef.name === "SNAME" ? row["NPROCENT_LOAD"] : null;
        return {
            padding: "8px",
            textOverflow: "ellipsis",
            overflow: "hidden",
            whiteSpace: "pre",
            ...(dayType
                ? {
                      backgroundColor: [1, 3].includes(dayType) ? "lightgrey" : dayType === 4 ? "lightgreen" : null,
                      color: [2, 3].includes(dayType) ? colors.blue : null
                  }
                : procentLoad || procentLoad === 0
                ? {
                      backgroundColor:
                          procentLoad >= 85 ? "lightgreen" : procentLoad >= 50 ? colors.lightyellow : procentLoad > 0 ? colors.lightred : "lightgrey"
                  }
                : {})
        };
    }
};

//------------------------------------
//Вспомогательные функции и компоненты
//------------------------------------

//Генерация заливки строки исходя от значений
const dataCellRender = ({ row, columnDef }) => ({
    cellProps: { title: row[columnDef.name] },
    cellStyle: STYLES.DATA_GRID_CELL(row, columnDef),
    data: row[columnDef]
});

//-----------
//Тело модуля
//-----------

//Корневая панель загрузки цеха
const MechRecDeptCostJobs = () => {
    //Собственное состояние - фильтр
    const [filter, setFilter, getWorkDays, getWorkHours] = useFilter(currentMonth, currentYear);

    //Собственное состояние - таблица данных
    const [costJobs, setCostJobs] = useMechRecDeptCostJobs(filter.department.NRN, filter.date.fullDate, filter.totalWorkHours);

    //При изменении состояния сортировки
    const handleOrderChanged = ({ orders }) => setCostJobs(pv => ({ ...pv, orders: [...orders], pageNumber: 1, reload: true }));

    //При изменении количества отображаемых страниц
    const handlePagesCountChanged = () => setCostJobs(pv => ({ ...pv, pageNumber: pv.pageNumber + 1, reload: true }));

    //При изменении месяца
    const handleMonthChange = side => {
        //Исходим от стороны, в которую идем
        let newDate =
            side === 1
                ? filter.date.month === 12
                    ? { month: 1, year: filter.date.year + 1 }
                    : { month: filter.date.month + 1, year: filter.date.year }
                : filter.date.month === 1
                ? { month: 12, year: filter.date.year - 1 }
                : { month: filter.date.month - 1, year: filter.date.year };
        //Формируем полное представление даты
        newDate.fullDate = newDate.month.toString().padStart(2, "0") + "." + newDate.year;
        //Считываем количество рабочих дней и обновляем состояние
        getWorkDays({ newDate, init: filter.init });
    };

    //При выборе подразделения
    const handleSelectDeparture = department => {
        //Если подразделение изменилось
        if (department.NRN !== filter.department.NRN) {
            //Получаем количество рабочих часов
            getWorkHours(department);
            //Обновляем таблицу загрузки цеха
            setCostJobs(pv => ({ ...pv, pageNumber: 1, reload: true }));
        } else {
            setFilter(pv => ({ ...pv, openedDepartment: false }));
        }
    };

    //Генерация содержимого
    return (
        <Box>
            <FilterComponent
                filter={filter}
                setFilter={setFilter}
                handleMonthChange={handleMonthChange}
                handleSelectDeparture={handleSelectDeparture}
            />
            <div style={STYLES.CONTAINER}>
                <Typography sx={STYLES.TITLE} variant={"h6"}>
                    {costJobs.dataLoaded ? `Загрузка станков "${filter.department.SNAME}"` : null}
                </Typography>
                <Box pt={1} display="flex" justifyContent="center" alignItems="center">
                    {costJobs.dataLoaded ? (
                        <P8PDataGrid
                            {...P8P_DATA_GRID_CONFIG_PROPS}
                            containerComponentProps={{ elevation: 6, style: STYLES.DATA_GRID_CONTAINER }}
                            fixedHeader={costJobs.fixedHeader}
                            fixedColumns={costJobs.fixedColumns}
                            columnsDef={costJobs.columnsDef}
                            rows={costJobs.rows}
                            size={P8P_DATA_GRID_SIZE.LARGE}
                            morePages={costJobs.morePages}
                            reloading={costJobs.reload}
                            onOrderChanged={handleOrderChanged}
                            onPagesCountChanged={handlePagesCountChanged}
                            dataCellRender={prms => dataCellRender({ ...prms })}
                        />
                    ) : null}
                </Box>
            </div>
        </Box>
    );
};

//----------------
//Интерфейс модуля
//----------------

export { MechRecDeptCostJobs };
