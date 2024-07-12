/*
    Парус 8 - Панели мониторинга - ПУП - Производственный план цеха
    Компонент панели: Таблица сдачи продукции
*/

//---------------------
//Подключение библиотек
//---------------------

import React from "react"; //Классы React
import PropTypes from "prop-types"; //Контроль свойств компонента
import { Typography, Box, Dialog, DialogContent, DialogActions, Button } from "@mui/material"; //Интерфейсные элементы
import { P8PDataGrid, P8P_DATA_GRID_SIZE } from "../../components/p8p_data_grid"; //Таблица данных
import { P8P_DATA_GRID_CONFIG_PROPS } from "../../config_wrapper"; //Подключение компонентов к настройкам приложения
import { useIncomFromDeps } from "./hooks"; //Хук состояния таблицы сдача продукции

//---------
//Константы
//---------

//Стили
const STYLES = {
    CONTAINER: { textAlign: "center" },
    TABLE: { paddingTop: "15px" }
};

//-----------
//Тело модуля
//-----------

//Таблица сдачи продукции
const IncomFromDepsDataGrid = ({ task }) => {
    //Собственное состояние - таблица данных
    const [incomFromDeps, setIncomFromDeps] = useIncomFromDeps(task);

    //При изменении состояния сортировки
    const handleOrderChanged = ({ orders }) => setIncomFromDeps(pv => ({ ...pv, orders: [...orders], pageNumber: 1, reload: true }));

    //При изменении количества отображаемых страниц
    const handlePagesCountChanged = () => setIncomFromDeps(pv => ({ ...pv, pageNumber: pv.pageNumber + 1, reload: true }));

    //Генерация содержимого
    return (
        <div style={STYLES.CONTAINER}>
            <Typography variant={"h6"}>Сдача продукции</Typography>
            <Box sx={STYLES.TABLE}>
                {incomFromDeps.dataLoaded ? (
                    <P8PDataGrid
                        {...P8P_DATA_GRID_CONFIG_PROPS}
                        columnsDef={incomFromDeps.columnsDef}
                        rows={incomFromDeps.rows}
                        size={P8P_DATA_GRID_SIZE.LARGE}
                        morePages={incomFromDeps.morePages}
                        reloading={incomFromDeps.reload}
                        onOrderChanged={handleOrderChanged}
                        onPagesCountChanged={handlePagesCountChanged}
                    />
                ) : null}
            </Box>
        </div>
    );
};

//Контроль свойств - Таблица сдачи продукции
IncomFromDepsDataGrid.propTypes = {
    task: PropTypes.number.isRequired
};

//Диалог с таблицей сдачи продукции
const IncomFromDepsDataGridDialog = ({ task, onClose }) => {
    return (
        <Dialog open onClose={onClose ? onClose : null} fullWidth maxWidth="xl">
            <DialogContent>
                <IncomFromDepsDataGrid task={task} />
            </DialogContent>
            {onClose ? (
                <DialogActions>
                    <Button onClick={onClose}>Закрыть</Button>
                </DialogActions>
            ) : null}
        </Dialog>
    );
};

//Контроль свойств - Диалог с таблицей сдачи продукции
IncomFromDepsDataGridDialog.propTypes = {
    task: PropTypes.number.isRequired,
    onClose: PropTypes.func
};

//----------------
//Интерфейс модуля
//----------------

export { IncomFromDepsDataGridDialog };
