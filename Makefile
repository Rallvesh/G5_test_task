.PHONY: all ansible monitoring down restart

# Развернуть всё
all: ansible monitoring

# Развёртывание ansible
ansible:
	cd ansible && ansible-playbook playbooks/vector.yaml

# Запуск docker-compose для Prometheus + Grafana
monitoring:
	cd prometheus-grafana && sudo docker compose up -d

# Остановка сервисов Prometheus + Grafana
down:
	cd prometheus-grafana && sudo docker compose down

# Перезапуск Prometheus + Grafana
restart:
	cd prometheus-grafana && sudo docker compose down && sudo docker compose up -d
