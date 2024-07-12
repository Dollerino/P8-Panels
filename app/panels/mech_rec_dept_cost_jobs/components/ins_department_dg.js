/*
    Парус 8 - Панели мониторинга - ПУП - Загрузка цеха
    Компонент панели: Таблица строк подразделений цехов
*/

//---------------------
//Подключение библиотек
//---------------------

import React from "react"; //Классы React
import PropTypes from "prop-types"; //Контроль свойств компонента
import { Typography } from "@mui/material"; //Интерфейсные элементы
import { P8PDataGrid, P8P_DATA_GRID_SIZE } from "../../../components/p8p_data_grid"; //Таблица данных
import { P8P_DATA_GRID_CONFIG_PROPS } from "../../../config_wrapper"; //Подключение компонентов к настройкам приложения
import { useInsDepartment } from "../hooks"; //Состояние таблицы подразделений цехов

//---------
//Константы
//---------

//Стили
const STYLES = {
    CONTAINER: { margin: "5px 0px", textAlign: "center" }
};

//------------------------------------
//Вспомогательные функции и компоненты
//------------------------------------

//Генерация ссылок на строках
const dataCellRender = ({ row, columnDef, handleSelectDeparture }) => {
    return {
        cellStyle: { cursor: "pointer", backgroundColor: "#ADD8E6" },
        cellProps: {
            onClick: () => {
                handleSelectDeparture({ NRN: row["NRN"], SCODE: row["SCODE"].toString(), SNAME: row["SNAME"] });
            }
        },
        data: row[columnDef.name]
    };
};

//-----------
//Тело модуля
//-----------

//Таблица строк подразделений цехов
const InsDepartmentDataGrid = ({ fullDate, handleSelectDeparture }) => {
    //Собственное состояние
    let [insDepartments, setInsDepartments] = useInsDepartment(fullDate);

    //При изменении количества отображаемых страниц
    const handlePagesCountChanged = () => setInsDepartments(pv => ({ ...pv, pageNumber: pv.pageNumber + 1, reload: true }));

    //Генерация содержимого
    return (
        <div style={STYLES.CONTAINER}>
            <Typography variant={"subtitle2"}>Подразделения цехов</Typography>
            {insDepartments.dataLoaded ? (
                <P8PDataGrid
                    {...P8P_DATA_GRID_CONFIG_PROPS}
                    columnsDef={insDepartments.columnsDef}
                    rows={insDepartments.rows}
                    size={P8P_DATA_GRID_SIZE.LARGE}
                    morePages={insDepartments.morePages}
                    reloading={insDepartments.reload}
                    onPagesCountChanged={handlePagesCountChanged}
                    dataCellRender={prms => dataCellRender({ ...prms, handleSelectDeparture })}
                />
            ) : null}
        </div>
    );
};

//Контроль свойств - Таблица строк подразделений цехов
InsDepartmentDataGrid.propTypes = {
    fullDate: PropTypes.string.isRequired,
    handleSelectDeparture: PropTypes.func.isRequired
};

//----------------
//Интерфейс модуля
//----------------

export { InsDepartmentDataGrid };
