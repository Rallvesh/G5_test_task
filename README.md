## Тестовое задание от G5 Games

Этот репозиторий предназначен для быстрого развертывания системы мониторинга с помощью:

- **Ansible** — для настройки хоста и установки Vector
- **Docker Compose** — для запуска контейнеров с Prometheus и Grafana

## Требования

- Ansible 2.10+
- Docker и Docker Compose
- git
- make (опционально)

## Клонирование репозитория и подготовка prometheus таргета

```
git clone https://github.com/Rallvesh/G5_test_task.git
cd G5_test_task
nano prometheus-grafana/prometheus-config/prometheus.yml
Заменить 10.10.20.129 на айпи хоста # Не придумал как корректно достучаться из контейнера с прометеем до порта вектора на локалхосте, поэтому это единственная правка руками
```

## Быстрый старт

В файле [_Makefile_](Makefile) описаны команды для разворачивания всех сервисов. Для использования необходимо установить утилиту make и запустить её:

```
sudo apt update
sudo apt install make
make all
```

Полный список команд:
```
make или make all — запустит ansible и docker compose

make ansible — только ansible-плейбук

make monitoring — только Prometheus+Grafana через Docker Compose

make down — остановка контейнеров

make restart — перезагрузка контейнеров
```

### Prometheus & Grafana

В файле [_compose.yaml_](prometheus-grafana/compose.yaml) описан деплой 2 сервисов `prometheus` и `grafana`.
Для графаны заданы креды admin/grafana.
При запуске docker compose открывает порты 80 для графаны и 9090 для прометея.
Запуск:

```
cd prometheus-grafana
sudo docker compose up -d
```

После запуска доступен дашборд Vector stats с метриками вектора.

## Ansible

В директории [_ansible_](ansible) предустановлена роль vector, написан простой конфиг и указана версия через групповые переменные. Запуск производится через команду:

```
cd ansible/
ansible-playbook playbooks/vector.yaml
```

## Ожидаемый результат:

Запущенные контейнеры:
```
$ docker ps
CONTAINER ID        IMAGE               COMMAND                  CREATED             STATUS              PORTS                    NAMES
dbdec637814f        prom/prometheus     "/bin/prometheus --c…"   8 minutes ago       Up 8 minutes        0.0.0.0:9090->9090/tcp   prometheus
79f667cb7dc2        grafana/grafana     "/run.sh"                8 minutes ago       Up 8 minutes        0.0.0.0:80->3000/tcp     grafana
```

Файл /var/log/test с агрегированнными логами контейнеров мониторинга.

Доступы:
```
http://<ip>:80           # графана
http://<ip>:9090         # прометей
http://<ip>:9598/metrics # метрики вектора
```
