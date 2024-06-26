"use strict";
var __decorate = (this && this.__decorate) || function (decorators, target, key, desc) {
    var c = arguments.length, r = c < 3 ? target : desc === null ? desc = Object.getOwnPropertyDescriptor(target, key) : desc, d;
    if (typeof Reflect === "object" && typeof Reflect.decorate === "function") r = Reflect.decorate(decorators, target, key, desc);
    else for (var i = decorators.length - 1; i >= 0; i--) if (d = decorators[i]) r = (c < 3 ? d(r) : c > 3 ? d(target, key, r) : d(target, key)) || r;
    return c > 3 && r && Object.defineProperty(target, key, r), r;
};
var __metadata = (this && this.__metadata) || function (k, v) {
    if (typeof Reflect === "object" && typeof Reflect.metadata === "function") return Reflect.metadata(k, v);
};
var __param = (this && this.__param) || function (paramIndex, decorator) {
    return function (target, key) { decorator(target, key, paramIndex); }
};
Object.defineProperty(exports, "__esModule", { value: true });
exports.UsersService = void 0;
const common_1 = require("@nestjs/common");
const mongoose_1 = require("@nestjs/mongoose");
const mongoose_2 = require("mongoose");
const users_model_1 = require("./users.model");
let UsersService = class UsersService {
    constructor(userModel) {
        this.userModel = userModel;
    }
    async findOne(email) {
        return this.userModel.findOne({ email }).exec();
    }
    async createUser(userData) {
        const createdUser = new this.userModel(userData);
        return createdUser.save();
    }
    async getAllUsers() {
        return this.userModel.find().exec();
    }
    async getUser(id) {
        return this.userModel.findById(id).exec();
    }
    async updateUser(id, updateData) {
        return await this.userModel.findByIdAndUpdate(id, updateData, { new: true }).exec();
    }
    async deleteUser(id) {
        return this.userModel.findByIdAndDelete(id).exec();
    }
    async updateRole(id, role) {
        return this.userModel.findByIdAndUpdate(id, { roles: [role] }, { new: true }).exec();
    }
    async getUserRole(id) {
        const user = await this.userModel.findById(id).exec();
        return user.roles;
    }
};
UsersService = __decorate([
    (0, common_1.Injectable)(),
    __param(0, (0, mongoose_1.InjectModel)(users_model_1.User.name)),
    __metadata("design:paramtypes", [mongoose_2.Model])
], UsersService);
exports.UsersService = UsersService;
//# sourceMappingURL=users.service.js.map