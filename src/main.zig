const std = @import("std");
const rl = @import("raylib");
const math = @import("std").math;

const Ship = struct {
    x: f32,
    y: f32,
    angle: f32, // Rotation in degrees

    pub fn drawShip(self: *Ship) void {
        const size: f32 = 40.0; // Ship size
        const half_size: f32 = size * 0.5;

        // Convert angle to radians for trigonometry
        const rad = self.angle * (math.pi / 180.0);

        // Compute ship's triangle vertices (rotated)
        const front = rl.Vector2{
            .x = self.x + math.cos(rad) * size,
            .y = self.y + math.sin(rad) * size,
        };

        const left = rl.Vector2{
            .x = self.x + math.cos(rad + 2.3) * half_size,
            .y = self.y + math.sin(rad + 2.3) * half_size,
        };

        const right = rl.Vector2{
            .x = self.x + math.cos(rad - 2.3) * half_size,
            .y = self.y + math.sin(rad - 2.3) * half_size,
        };

        const mid_left = rl.Vector2{
            .x = (left.x * 0.80 + front.x * 0.20),
            .y = (left.y * 0.80 + front.y * 0.20),
        };

        const mid_right = rl.Vector2{
            .x = (right.x * 0.80 + front.x * 0.20),
            .y = (right.y * 0.80 + front.y * 0.20),
        };

        // Draws the ship
        rl.drawLineV(front, right, rl.Color.white);
        rl.drawLineV(front, left, rl.Color.white);
        rl.drawLineV(mid_left, mid_right, rl.Color.white);
    }

    pub fn move(self: *Ship, key: u8) void {
        switch (key) {
            'w' => {
                // Ship movement
                const rad = self.angle * (math.pi / 180.0);
                const speed: f32 = 5.0;

                self.x += math.cos(rad) * speed;
                self.y += math.sin(rad) * speed;

                // Draws ship thrust
                const size: f32 = 25.0;
                const half_size = size / 2.0;

                const front = rl.Vector2{
                    .x = self.x - math.cos(rad) * size,
                    .y = self.y - math.sin(rad) * size,
                };
                const left = rl.Vector2{
                    .x = self.x - math.cos(rad + 0.5) * half_size,
                    .y = self.y - math.sin(rad + 0.5) * half_size,
                };
                const right = rl.Vector2{
                    .x = self.x - math.cos(rad - 0.5) * half_size,
                    .y = self.y - math.sin(rad - 0.5) * half_size,
                };

                rl.drawLineV(front, right, rl.Color.white);
                rl.drawLineV(front, left, rl.Color.white);
            },
            'a' => {
                self.updateAngle('a');
            },
            'd' => {
                self.updateAngle('d');
            },

            else => {},
        }
    }

    fn updateAngle(self: *Ship, key: u8) void {
        if (key == 'a') self.angle -= 5;
        if (key == 'd') self.angle += 5;
    }
};

pub fn main() !void {
    rl.initWindow(1280, 720, "Asteroids");
    defer rl.closeWindow();
    rl.setTargetFPS(60);

    var player = Ship{ .x = 640.0, .y = 360.0, .angle = -90.0 }; // Start at center

    while (!rl.windowShouldClose()) {
        rl.beginDrawing();
        defer rl.endDrawing();
        rl.clearBackground(rl.Color.black);

        player.drawShip();

        // Ship controls
        if (rl.isKeyDown(rl.KeyboardKey.w)) player.move('w');
        if (rl.isKeyDown(rl.KeyboardKey.a)) player.move('a');
        if (rl.isKeyDown(rl.KeyboardKey.d)) player.move('d');
    }
}
