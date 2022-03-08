

keys/.created: # just a target to make sure we have generated keys
	../create-keys.sh

# manufacturing-server secrets
manufacturing-server/secrets/%.pem: keys/%.pem
	cp $< $@

manufacturing-server/secrets/%.der: keys/%.der
	cp $< $@


MANUFACTURING_SERVER_SECRETS=manufacturing-server/secrets/diun_key.der manufacturing-server/secrets/diun_cert.pem \
							 manufacturing-server/secrets/manufacturer_key.der manufacturing-server/secrets/manufacturer_cert.pem \
							 manufacturing-server/secrets/device_ca_key.der  manufacturing-server/secrets/device_ca_cert.pem \
							 manufacturing-server/secrets/owner_cert.pem


# rendezvous-server secrets
rendezvous-server/secrets/%.pem: keys/%.pem
	cp $< $@

RENDEZVOUS_SECRETS=rendezvous-server/secrets/manufacturer_cert.pem

# onboarding-server secrets
onboarding-server/secrets/%.pem: keys/%.pem
	cp $< $@

onboarding-server/secrets/%.der: keys/%.der
	cp $< $@

ONBOARDING_SERVER_SECRETS=onboarding-server/secrets/owner_key.der onboarding-server/secrets/owner_cert.pem \
						  onboarding-server/secrets/device_ca_cert.pem
						  

secrets: keys/.created $(MANUFACTURING_SERVER_SECRETS) $(RENDEZVOUS_SECRETS) $(ONBOARDING_SERVER_SECRETS)
.PHONY: secrets

manifest: secrets
	@kubectl kustomize ./manufacturing-server
	@echo "---"
	@kubectl kustomize ./rendezvous-server
	@echo "---"
	@kubectl kustomize ./onboarding-server
.PHONY: manifest
