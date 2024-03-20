CFLAGS += -pedantic
CFLAGS += -Wp,-U_FORTIFY_SOURCE
CFLAGS += -O2 -march=native -mtune=native
CFLAGS += -Wall -Wextra

CFLAGS += -Werror=vla-larger-than=0

BUILD_DIR := .build

LDFLAGS := -fwhole-program -flto

OBJ := $(SRC:%.c=$(BUILD_DIR)/release/%.o)
OBJ_DEBUG := $(SRC:%.c=$(BUILD_DIR)/debug/%.o)

.PHONY: all
all: $(OUT)

OUT_DEBUG = $(OUT)-debug

.PHONY: debug
debug: $(OUT_DEBUG)

$(OUT): $(OBJ)
	@ mkdir -p $(dir $@)
	$Q $(CC) -o $@ $(OBJ) $(CFLAGS) $(LDLIBS) $(LDFLAGS)
	@ $(LOG_TIME) "LD $(C_GREEN) $@ $(C_RESET)"

$(OUT_DEBUG): CFLAGS += -g3
$(OUT_DEBUG): $(OBJ_DEBUG)
	@ mkdir -p $(dir $@)
	$Q $(CC) -o $@ $(OBJ_DEBUG) $(CFLAGS) $(LDLIBS) $(LDFLAGS)
	@ $(LOG_TIME) "LD $(C_GREEN) $@ $(C_RESET)"

$(BUILD_DIR)/release/%.o: %.c
	@ mkdir -p $(dir $@)
	$Q $(CC) $(CFLAGS) -o $@ -c $< || exit 1
	@ $(LOG_TIME) "CC $(C_PURPLE) $(notdir $@) $(C_RESET)"

$(BUILD_DIR)/debug/%.o: %.c
	@ mkdir -p $(dir $@)
	$Q $(CC) $(CFLAGS) -o $@ -c $< || exit 1
	@ $(LOG_TIME) "CC $(C_PURPLE) $(notdir $@) $(C_RESET)"

.PHONY: clean
clean:
	$(RM) $(OBJ)
	@ $(LOG_TIME) $@

.PHONY: fclean
fclean: clean
	$(RM) -r $(BUILD_DIR) $(OUT) $(OUT_DEBUG)
	@ $(LOG_TIME) $@

.PHONY: re
re: fclean
	@ $(MAKE) all

-include hook.end.mk
