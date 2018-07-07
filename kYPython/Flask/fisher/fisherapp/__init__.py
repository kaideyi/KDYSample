from flask import Flask
from flask_login import LoginManager
from fisherapp.models.base import db

login_manager = LoginManager()

def create_app():
    app = Flask(__name__)
    app.config.from_object('fisherapp.secure')  # 引入配置文件的路径 
    app.config.from_object('fisherapp.setting')
    register_blueprint(app)

    db.init_app(app)
    login_manager.init_app(app)
    login_manager.login_view = 'web.login'
    login_manager.login_message = '请先登录或注册'

    db.create_all(app=app) # 生成数据表
    return app

def register_blueprint(app):
    from fisherapp.web.book import web
    # from fisherapp.web.user import user
    app.register_blueprint(web)