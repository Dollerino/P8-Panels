/*
    Парус 8 - Панели мониторинга - ПУП - Производственный план цеха
    Компонент панели: Таблица строк маршрутного листа
*/

//---------------------
//Подключение библиотек
//---------------------

import React from "react"; //Классы React
import PropTypes from "prop-types"; //Контроль свойств компонента
import { Typography } from "@mui/material"; //Интерфейсные элементы
import { P8PDataGrid, P8P_DATA_GRID_SIZE } from "../../components/p8p_data_grid"; //Таблица данных
import { P8P_DATA_GRID_CONFIG_PROPS } from "../../config_wrapper"; //Подключение компонентов к настройкам приложения
import { useCostRouteListsSpecs } from "./hooks.js"; //Хук состояния таблицы строк маршрутного листа

//---------
//Константы
//---------

//Стили
const STYLES = {
    CONTAINER: { margin: "5px 0px", textAlign: "center" }
};

//-----------
//Тело модуля
//-----------

//Таблица строк маршрутного листа
const CostRouteListsSpecsDataGrid = ({ mainRowRN }) => {
    //Собственное состояние - таблица данных
    const [costRouteListsSpecs, setCostRouteListsSpecs] = useCostRouteListsSpecs(mainRowRN);

    //При изменении состояния сортировки
    const handleOrderChanged = ({ orders }) => setCostRouteListsSpecs(pv => ({ ...pv, orders: [...orders], pageNumber: 1, reload: true }));

    //При изменении количества отображаемых страниц
    const handlePagesCountChanged = () => setCostRouteListsSpecs(pv => ({ ...pv, pageNumber: pv.pageNumber + 1, reload: true }));

    //Генерация содержимого
    return (
        <div style={STYLES.CONTAINER}>
            <Typography variant={"subtitle2"}>Операции</Typography>
            {costRouteListsSpecs.dataLoaded ? (
                <P8PDataGrid
                    {...P8P_DATA_GRID_CONFIG_PROPS}
                    columnsDef={costRouteListsSpecs.columnsDef}
                    rows={costRouteListsSpecs.rows}
                    size={P8P_DATA_GRID_SIZE.SMALL}
                    morePages={costRouteListsSpecs.morePages}
                    reloading={costRouteListsSpecs.reload}
                    onOrderChanged={handleOrderChanged}
                    onPagesCountChanged={handlePagesCountChanged}
                />
            ) : null}
        </div>
    );
};

//Контроль свойств - Таблица строк маршрутного листа
CostRouteListsSpecsDataGrid.propTypes = {
    mainRowRN: PropTypes.number.isRequired
};

//----------------
//Интерфейс модуля
//----------------

export { CostRouteListsSpecsDataGrid };
