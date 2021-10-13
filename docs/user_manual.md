# Руководство пользователя

## 1. Назначение программы
Программа предназначена для генерации аппаратного описания на языке Verilog HDL функций сравнения в модулярной арифметике. Программа предоставляет возможности выбора базиса модулярной арифметики, типа сравнения и других характеристик выходных данных. Помимо этого программа генерирует модули верификации получаемых аппаратных описаний. 
Для генерации предоставляется выбор между двумя методами сравнения: основанном на переводе сравниваемых чисел в двоичное представление и основанный на предварительном вычитании с последующим переводом результата в двоичное представление. Возможна генерация модуля сравнения с константой одним из доступных методом.
Для применения первого метода сравнения необходимо отдельно получить аппаратное описание модуля быстрого перевода, используя генератор, расположенный в [свободном доступе в сети “Интернет”](http://vscripts.ru/2012/reverse-converter-2supn-generator.php). Для этого метода доступно использованием базисов вида {2<sup>n</sup>-1; 2<sup>n</sup>; 2<sup>n</sup>+1}, где 2 < n < 44. Данный метод позволяет сравнивать числа в диапазоне от 0 до (2<sup>n</sup>-1 * 2<sup>n</sup> * 2<sup>n</sup>+1)-1. Второй из доступных методов также производит сравнение в базисе вида {2<sup>n</sup>-1; 2<sup>n</sup>; 2<sup>n</sup>+1}, где n > 2. Диапазон значений второго метода ограничен значениями от 0 до (2<sup>n</sup>-1 * 2<sup>n</sup> * 2<sup>n</sup>+1) / 2.
В модулях верификации для операции сравнения чисел в базисе с n < 44 применяется случайная генерация тестовых случаев. Число тестовых случаев может быть выбрано в диапазоне от 1 до 65536.

## 2. Условия выполнения программы
### 2.1 Минимальный состав аппаратных средств
Компьютер с монитором, мышью и клавиатурой, процессор с тактовой частотой 1 ГГц или выше, 2 Гб ОЗУ и выходом в сеть “Интернет”.
Для запуска модулей сравнения на ПЛИС рекомендуется использовать устройство на основе ПЛИС с 100 000 логическими элементами, 5000 Кбит. встроенной памяти.

### 2.2 Минимальный состав программных средств
Операционная система Windows 10 или Ubuntu 18.04 или macOS Mojave 10.14.6. Интерпретатор языка Python версии 3.7 и выше. Интернет браузер Google Chrome 89 или Mozilla Firefox 85 или Apple Safari 14 или аналогичный. Пакеты Python: 
- veriloggen 1.9.1, 
- argparse 1.1, 
- pytest 6.2.2. 

Для проверки работы модулей verilog необходим набор утилит Icarus Verilog 11. Для компиляции, синтеза и запуска модулей с использованием устройства на базе ПЛИС используйте пакет программ, рекомендуемых производителем соответствующего аппаратного обеспечения. 

## 3. Запуск программы
Для запуска программы используется интерпретатор языка python. Перед запуском необходимо перейти в директорию, содержащую исходный код программы, с использованием командной строки. После этого необходимо переместиться в поддиректорию `python` и выполнить следующую команду:

#### Linux/MacOS:
```
python3 generator.py {mandatory} [optional]
```
#### Windows:
```
python generator.py {mandatory} [optional]
```
Параметры `mandatory` — список обязательных параметров для генерации, среди которых:
- `-n N` — Параметр числа n для модулярного базиса {2<sup>n</sup>-1; 2<sup>n</sup>; 2<sup>n</sup>+1}. Значение N должно быть натуральным числом больше 2.
- `-m METHOD` — Параметр выбора метода сравнения. METHOD может быть `naive` для выбора метода сравнения с использованием обратного преобразования в двоичную систему счисления обоих аргументов (число n ограничено 43) или `lei_li_2013` для выбора метода, основанного на предварительном модульном вычитании двух операндов с последующим переводом результата в двоичную систему.

Список `optional` — список опциональных параметров для генерации, среди которых:
- `-h` — Флаг для вывода краткой справки на английском языке.
- `-o OUTPUT` — Параметр выбора пути к verilog-файлу. По умолчанию задан файл `a.v`
- `-c` CONST — Параметр выбора генерации модуля сравнения с константой CONST. Константа должна быть натуральным числом (0 <= const < Max, Max — число, максимально возможное для заданного базиса и выбранного метода). 
- `-p` — Флаг демонстрации результата с использованием стандартного вывода.
- `-t` — Флаг генерации тестового модуля для модуля сравнения.     
- `-k TC` — Параметр выбора числа случайных тестовых вариаций в модуле сравнения. Применяется для случаем выбора базиса с n > 7. TC должно быть натуральным числом больше 0 и меньше 65536. 

## 4. Сообщения пользователю
При выборе параметра вывода краткой справки выводится следующее сообщение: 

```
usage: generator.py [-h] -n N -m METHOD [-o OUTPUT] [-c CONST] [-p] [-t] [-k TC]

Generates Verilog HDL modules for compare operation for Residue Number Systems with moduli \{2^n-1; 2^n; 2^n+1\}

optional arguments:
  -h, --help            show this help message and exit
  -n N                  n value for moduli set \{2^n-1; 2^n; 2^n+1\}
  -m METHOD, --method METHOD
                        Choose compare method: naive, lei_li_2013
  -o OUTPUT, --output OUTPUT
                        Output file name
  -c CONST, --const CONST
                        Generate compare with const (Defaut: compare two numbers). Integer constant should be defined (0 <= const < Max).
  -p, --print           Print result to std output
  -t, --testbench       Generate testbench
  -k TC, --testcases TC
                        Set the number of testcases, when n > 7 (Defaut: 2000). he number of test cases must be greater then 0 and less 65536
```

При пропуске обязательного параметра будет выведено сообщение:
```
error: the following arguments are required: [mandatory param] 
```
Требуется перезапуск программы с использованием всех необходимых параметров.
При выборе некорректного метода или n для базиса, либо некорректной константы для сравнения, либо некорректного число тестовых случаев будет выведено сообщение, указывающее диапазон возможных значений соответствующего параметра. Аналогичное поведение программы происходит при выборе неверного пути  выходному файлу. Например: 
```
n must be greater than 3
```
Необходимо устранить ошибку и перезапустить программу.
При успешном завершении генерации вывод сообщение не производится, кроме случая выбора флага печати результата в стандартный поток вывода.