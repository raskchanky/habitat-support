start:
	vagrant up --provision
	$(MAKE) run

build:
	vagrant ssh -c 'cd /src && make clean build-srv'

run:
	vagrant ssh -c 'cd /src && sudo ./support/linux/bin/forego start -f /scripts/Procfile -e ./support/bldr.env'

load: origins keys project upload_all job

origins:
	http POST http://localhost:9636/v1/depot/origins \
		Authorization:Bearer:$(HAB_AUTH_TOKEN) \
		name=core

	http POST http://localhost:9636/v1/depot/origins \
		Authorization:Bearer:$(HAB_AUTH_TOKEN) \
		name=cnunciato

keys:
	cat ~/.hab/cache/keys/core-20160810182414.pub | \
		http POST http://localhost:9636/v1/depot/origins/core/keys/20160810182414 \
		Authorization:Bearer:$(HAB_AUTH_TOKEN)

	cat ~/.hab/cache/keys/core-20160810182414.sig.key | \
		http POST http://localhost:9636/v1/depot/origins/core/secret_keys/20160810182414 \
		Authorization:Bearer:$(HAB_AUTH_TOKEN)

	cat ~/.hab/cache/keys/cnunciato-20170304222818.pub | \
		http POST http://localhost:9636/v1/depot/origins/cnunciato/keys/20170304222818 \
		Authorization:Bearer:$(HAB_AUTH_TOKEN)

	cat ~/.hab/cache/keys/cnunciato-20170304222818.sig.key | \
		http POST http://localhost:9636/v1/depot/origins/cnunciato/secret_keys/20170304222818 \
		Authorization:Bearer:$(HAB_AUTH_TOKEN)

install:
	vagrant ssh -c "HAB_DEPOT_URL='' sudo hab pkg install ${IDENT}"

upload:
	vagrant ssh -c "sudo hab pkg upload --url http://localhost:9636/v1/depot --auth ${HAB_AUTH_TOKEN} /hab/cache/artifacts/${IDENT}"

project:
	$(MAKE) project_core_linux-headers

project_core_%:
	echo '{ \
		"origin": "core",\
		"plan_path": "$*/plan.sh",\
		"github": {\
			"organization": "habitat-sh",\
			"repo": "core-plans"\
		}\
	}' | http POST http://localhost:9636/v1/projects Authorization:Bearer:$(HAB_AUTH_TOKEN) --verify no

job:
	$(MAKE) job_core_linux-headers

job_core_%:
	http POST http://localhost:9636/v1/jobs \
		Authorization:Bearer:$(HAB_AUTH_TOKEN) project_id="core/$*"

upload_all:
	vagrant ssh -c "sudo /scripts/migrate.sh"

open:
	open http://localhost:3000/#/pkgs

login:
	vagrant ssh

suspend:
	vagrant suspend

reload:
	vagrant reload

restore:
	vagrant restore

clean: destroy

destroy:
	vagrant destroy -f

snapshot:
	vagrant snapshot push

unsnapshot:
	vagrant snapshot pop
