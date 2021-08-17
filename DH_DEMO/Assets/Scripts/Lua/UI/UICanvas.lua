local ui_camera = UE.GameObject.FindGameObjectsWithTag("UICamera")[0]


local canvas = cs_self.gameObject:GetComponent(typeof(UE.Canvas))
canvas.renderMode = UE.RenderMode.ScreenSpaceCamera;
canvas.worldCamera = ui_camera:GetComponent(typeof(UE.Camera))