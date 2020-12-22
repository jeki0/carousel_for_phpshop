# Карусель на slick для PhpShop

1. Скопировать директорию slidercarousel в phpshop\admpanel 
Скопировать директорию из папки templates в phpshop\templates\ВАША_ТЕМА\

2. Добавить строку в domains\sta\phpshop\admpanel\admin.php для того что бы пункт появился в меню
```html
<li><a href="?path=slidercarousel"><span>Слайдер - Carousel</span><span class="dropdown-header">Рекламный слайдер на главной странице</span></a></li>
```

3. Добавить строку в phpshop\admpanel\exchange\admin_sql.php 
```php
"phpshop_slidercarousel" => 'Слайдер на главной странице'
```

4. Добавить строки в phpshop\admpanel\users\adm_usersID.php поместить лучше около стандартной карусели
```php
"slidercarousel" => rules_zero($_POST[slidercarousel_rul_1]) . "-" . rules_zero($_POST[slidercarousel_rul_2]) . "-" . rules_zero($_POST[slidercarousel_rul_3]),
```

5. В phpshop\admpanel\users\adm_users_new.php
```php
"slidercarousel" => rules_zero($_POST[slidercarousel_rul_1]) . "-" . rules_zero($_POST[slidercarousel_rul_2]) . "-" . rules_zero($_POST[slidercarousel_rul_3]),
```

6. В phpshop\admpanel\users\gui\tab_rules.gui.php
```php
<tr>
<td>СлайдерCarousel</td>
<td>' . $PHPShopGUI->setCheckbox('slidercarousel_rul_1', 1, false, rules_checked($status[slidercarousel], 0)) . '</td>
<td>' . $PHPShopGUI->setCheckbox('slidercarousel_rul_2', 1, false, rules_checked($status[slidercarousel], 1)) . '</td>
<td>' . $PHPShopGUI->setCheckbox('slidercarousel_rul_3', 1, false, rules_checked($status[slidercarousel], 2)) . '</td>
<td>-</td>
<td>-</td>
</tr>
```

7. В phpshop\inc\autoload.inc.php
```php
// ZEA Слайдер - Карусель
$PHPShopSlidercarouselElement = new PHPShopSlidercarouselElement();
$PHPShopSlidercarouselElement->init('imageSlider2');
```

8. phpshop\inc\config.ini 
```php
slidercarousel = "phpshop_slidercarousel";
```

9. Создать таблицу в БД phpshop_slidercarousel. Полная копия стандартной таблицы slider

10. Подключить к шаблону slick
https://github.com/kenwheeler/slick

11. Укажите в шаблоне @imageSlider2@ в том месте где должна быть карусель

12. Добавить код в phpshop\inc\elements.inc.php
```php
/**
 * ZEA
 * Элемент вывода изображений в слайдер
 * @author PHPShop Software
 * @version 1.0
 * @package PHPShopElements
 */
class PHPShopSlidercarouselElement extends PHPShopElements {

    /**
     * @var bool Показывать слайдер только на главной
     */
    var $disp_only_index = false;

    /**
     * @var int  Кол-во изображений
     */
    var $limit = 20;
	
	/**
     * @var int  Количество отображаемых 
     */
    var $show_items = 4;

    /**
     * Конструктор
     */
    function __construct() {
        $this->debug = false;
        $this->objBase = $GLOBALS['SysValue']['base']['slidercarousel'];
        parent::__construct();
    }

    /**
     * Вывод изображений в слайдер
     * @return string
     */
    function index() {
        global $PHPShopModules;
        static $i;
        $dis = null;

        // Выполнение только на главной странице
        if ($this->disp_only_index) {
            if ($this->PHPShopNav->index())
                $view = true;
            else
                $view = false;
        }
        else
            $view = true;
        if (!empty($view)) {
            $result = $this->PHPShopOrm->select(array('image', 'alt', 'link'), array('enabled' => '="1"'), array('order' => 'num, id DESC'), array("limit" => $this->limit));

            // Проверка на еденичную запись
            if ($this->limit > 1)
                $data = $result;
            else
                $data[] = $result;

            if (is_array($data))
                foreach ($data as $row) {

                    // Определяем переменные
                    $this->set('image', $row['image']);
                    $this->set('alt', $row['alt']);
                    $this->set('link', $row['link']);


                    // Активный слайдер
                    if (empty($i)) {
                        $this->set('slideActive', 'active');
                        $this->set('slideIndicator', '<li data-target="#carousel-example-generic" data-slide-to="0" class="active"></li>', true);
                    } else {
                        $this->set('slideActive', '');
                        $this->set('slideIndicator', '<li data-target="#carousel-example-generic" data-slide-to="' . $i . '"></li>', true);
                    }

                    $i++;

                    // Перехват модуля
                    $PHPShopModules->setHookHandler(__CLASS__, __FUNCTION__, $this, $row);

                    // Подключаем шаблон
                    $dis.=$this->parseTemplate("/slidercarousel/slidercarousel_oneImg.tpl");
                }
            if (@$dis) {
				$this->set('show_items', $this->show_items);
                $this->set('imageSliderContent', $dis);
                return$this->parseTemplate("/slidercarousel/slidercarousel_main.tpl");
            }
            return false;
        }
    }
}
```

