# Atajos para live/. Antes: correr el repo bootstrap (a mano, una vez).
#   make plan                # todo dev
#   make apply ENTORNO=qa    # todo qa
#   make plan UNIDAD=ec2     # solo live/dev/ec2 (iam-ssm | ec2 | dynamodb)
ENTORNO    ?= dev
UNIDAD     ?=
TG         ?= terragrunt
AWS_REGION ?= us-east-1
export AWS_REGION

# El provider se baja una vez para todas las unidades.
export TG_PROVIDER_CACHE := 1

ifeq ($(UNIDAD),)
  DIR := live/$(ENTORNO)
  RUN := $(TG) run --all
else
  DIR := live/$(ENTORNO)/$(UNIDAD)
  RUN := $(TG) run
endif

.PHONY: plan apply destroy output fmt validate clean check-env

plan: check-env
	cd $(DIR) && $(RUN) plan

apply: check-env
	cd $(DIR) && $(RUN) apply

destroy: check-env
	cd $(DIR) && $(RUN) destroy

output: check-env
	cd $(DIR) && $(RUN) output

fmt:
	terraform fmt -recursive modules
	$(TG) hcl fmt

validate: export TF_PLUGIN_CACHE_DIR := $(HOME)/.terraform.d/plugin-cache
validate:
	@mkdir -p $(TF_PLUGIN_CACHE_DIR)
	@for m in $(dir $(wildcard modules/*/main.tf)); do \
	  echo ">> $$m"; \
	  (cd $$m && terraform init -backend=false -input=false >/dev/null && terraform validate) || exit 1; \
	done

clean:
	find . -type d \( -name .terragrunt-cache -o -name .terraform \) -prune -exec rm -rf {} +
	find modules -name .terraform.lock.hcl -delete

check-env:
	@test -d $(DIR) || { echo "No existe $(DIR)"; exit 1; }
