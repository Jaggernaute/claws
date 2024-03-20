include base.mk

BINARIES += linear-structure/stack/stack

BINARIES-DEBUG := $(BINARIES:%=%-debug)

define make-rule
@ $(MAKE) -C $(1) $(2)

endef

prop = $(foreach b, $(BINARIES), $(call make-rule, $(dir $b), $(1)))

.PHONY: all
all: $(BINARIES)

.PHONY: debug
debug: $(BINARIES-DEBUG)

$(BINARIES-DEBUG):
	$(call make-rule, $(dir $@), $(notdir $@))

$(BINARIES):
	$(call make-rule, $(dir $@), $(notdir $@))

.PHONY: clean
clean:
	$(call prop, clean)

.PHONY: fclean
fclean:
	$(call prop, fclean)

.PHONY: re
re:
	$(call prop, re)
