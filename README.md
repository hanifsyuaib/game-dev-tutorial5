# Tutorial 3 - Introduction to Game Programming

## Penjelasan Proses Pengerjaan Fitur Lanjutan

Terdapat tiga fitur lanjutan ke dalam karakter pemain, yaitu **Double Jump**, **Dashing**, dan **Crouching**. Berikut adalah penjelasan masing-masing fitur lanjutan.

### 1. Double Jump

- **Inisialisasi Variabel:**
  ```gdscript
  var jump_count = 0
  var max_jumps = 2
  ```

- **Reset Jumlah Lompatan saat Menyentuh Floor:**
  ```gdscript
  if is_on_floor():
      jump_count = 0
  ```

- **Memeriksa dan Update Input Lompatan:**
  ```gdscript
  if Input.is_action_just_pressed('ui_up') and jump_count < max_jumps:
      velocity.y = jump_speed
      jump_count += 1
  ```


### 2. Dashing

- **Inisialisasi Variabel:**
  ```gdscript
  @export var dash_speed = 500
  @export var dash_duration = 0.5
  var is_dashing = false
  var dash_time_left = 0
  var dash_direction = 0
  var last_input = ""
  var last_input_time = 0
  var double_tap_time = 0.3
  ```

- **Menangani Input untuk Dash:**

    Fungsi `handle_dash_input()` mendeteksi double tap pada tombol kiri (`ui_left`) atau kanan (`ui_right`) untuk memulai dash. Fungsi akan mencatat waktu saat tombol ditekan dan membandingkannya dengan input sebelumnya. Jika pemain menekan tombol yang sama dua kali dalam selang waktu kurang dari `double_tap_time` (0.3 detik) maka fungsi `start_dash()` akan dipanggil dengan arah sesuai tombol yang ditekan (kiri: `-1`, kanan: `1`).

  ```gdscript
  func handle_dash_input():
      var current_time = Time.get_ticks_msec() / 1000.0

      if Input.is_action_just_pressed("ui_left"):
          if last_input == "left" and (current_time - last_input_time) < double_tap_time:
              start_dash(-1)
          last_input = "left"
          last_input_time = current_time

      elif Input.is_action_just_pressed("ui_right"):
          if last_input == "right" and (current_time - last_input_time) < double_tap_time:
              start_dash(1)
          last_input = "right"
          last_input_time = current_time
  ```

- **Memulai Dash:**

    Fungsi `start_dash(direction)` digunakan untuk memulai aksi dash pada karakter. Jika karakter tidak sedang dalam kondisi dash (`is_dashing == false`), maka fungsi akan mengatur `is_dashing` menjadi `true` dimana menetapkan sisa waktu dash (`dash_time_left`) sesuai dengan `dash_duration` dan menentukan arah dash berdasarkan parameter direction (kiri: -1, kanan: 1).

  ```gdscript
  func start_dash(direction):
      if not is_dashing:
          is_dashing = true
          dash_time_left = dash_duration
          dash_direction = direction
  ```

- **Mengatur Kecepatan saat Dash:**
  ```gdscript
  if is_dashing:
      velocity.x = dash_speed * dash_direction
  ```

### 3. Crouching

- **Inisialisasi Variabel:**
  ```gdscript
  @export var crouch_speed = 100
  var is_crouching = false
  @onready var sprite = $Sprite2D
  ```

- **Menangani Input dan mengganti Sprite untuk Crouch:**
  ```gdscript
  func handle_crouching():
      if Input.is_action_pressed("ui_down") and is_on_floor():
          is_crouching = true
          sprite.texture = preload("res://assets/kenney_platformercharacters/PNG/Zombie/Poses/zombie_duck.png")
      else:
          is_crouching = false
          sprite.texture = preload("res://assets/kenney_platformercharacters/PNG/Zombie/Poses/zombie_stand.png")
  ```

- **Mengatur Kecepatan dan Arah saat Crouch:**
  ```gdscript
  if is_crouching:
      if Input.is_action_pressed("ui_left"):
          velocity.x = -crouch_speed
          sprite.flip_h = true
      elif Input.is_action_pressed("ui_right"):
          velocity.x = crouch_speed
          sprite.flip_h = false
      else:
          velocity.x = 0
  ```

## Referensi

1. [How to Double Jump in Godot 4](https://www.youtube.com/watch?v=CAMHDTZdSCs)
2. [How To Dash & Double Jump - Godot 4 2D Tutorial](https://www.youtube.com/watch?v=NhHpDcpY8ok)
